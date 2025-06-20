'use client';

import {useEffect, useState} from 'react';
import withAdminAuth from "@/components/withAdmin";
import {
    Box,
    Button,
    Grid,
    List,
    ListItem,
    ListItemIcon,
    ListItemText,
    TextField,
    Typography
} from '@mui/material';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';
import RefreshIcon from '@mui/icons-material/Refresh';
import axios from "axios";
import MuiAlert, {AlertProps} from '@mui/material/Alert';
import React from "react";
import { DatePicker, LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns'; // Import the date adapter

import {useRouter} from 'next/navigation'; // Import useRouter for navigation

import NavBar from '@/components/Navbar';

function Home() {
    const router = useRouter(); // Initialize useRouter

    const [snackbarQueue, setSnackbarQueue] = useState<{ message: string, severity: 'success' | 'error' }[]>([]);
    const [currentSnackbar, setCurrentSnackbar] = useState<{
        message: string,
        severity: 'success' | 'error'
    } | null>(null);

    const [selectedVehicle, setSelectedVehicle] = useState<any>(null);
    const [vehicleReports, setVehicleReports] = useState<object[]>([]);
    const [selectedDate, setSelectedDate] = useState<Date | null>(null);

    useEffect(() => {
        if (!currentSnackbar && snackbarQueue.length > 0) {
            setCurrentSnackbar(snackbarQueue[0]);
        }
    }, [snackbarQueue, currentSnackbar]);

    const showSnackbar = (message: string, severity: 'success' | 'error') => {
        setSnackbarQueue(prevQueue => [...prevQueue, {message, severity}]);
    };

    const Alert = React.forwardRef<HTMLDivElement, AlertProps>(function Alert(
        props,
        ref,
    ) {
        return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
    });


    const url = process.env.API_URL || 'http://localhost:3000';

    const fetchVehicleReports = (date?: Date) => {
        const endpoint = `/api/v1/driver/report${date ? `?time=${date.toISOString()}` : ''}`;
        const token = localStorage.getItem('token');

        axios.get(url + endpoint, {
            headers: {
                Authorization: token,
            }
        })
            .then(response => {
                setVehicleReports(response.data.data);
            })
            .catch(error => {
                showSnackbar('Error fetching vehicle reports: ' + error.message, 'error');
                console.error('Error fetching vehicle reports:', error);
            });
    };

    const handleDateChange = (date: Date | null) => {
        setSelectedDate(date);
        if (date) {
            fetchVehicleReports(date);
        }
    };

    useEffect(() => {
        // Add Axios interceptor
        const interceptor = axios.interceptors.response.use(
            response => response,
            error => {
                if (error.response && error.response.status === 401) {
                    localStorage.removeItem('token'); // Remove token from localStorage
                    router.push('/login'); // Redirect to logout page
                }
                return Promise.reject(error);
            }
        );

        // Cleanup interceptor on component unmount
        return () => {
            axios.interceptors.response.eject(interceptor);
        };
    }, [router]);

    useEffect(() => {
        fetchVehicleReports();
    }, []);

    const handleVehicleClick = (vehicle: any) => {
        setSelectedVehicle(vehicle);
    };

    const navbarPages = [
        {title: 'Home', url: '/'},
    ];

    return (
        <LocalizationProvider dateAdapter={AdapterDateFns}>
            <NavBar pages={navbarPages} title={'Vehicle Reports'}/>
            <div className="p-4">
                <Grid container spacing={2} justifyContent="center" className='mt-10'>
                    <Grid item xs={12} md={6}>
                        <Box className="p-4 border rounded shadow">
                            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                                <Typography variant="h5" gutterBottom>Vehicles</Typography>
                                <Button onClick={() => fetchVehicleReports()}>
                                    <RefreshIcon/>
                                </Button>
                            </Box>
                            <Box mb={2}>
                                <DatePicker
                                    label="Select Date"
                                    value={selectedDate}
                                    onChange={handleDateChange}
                                    renderInput={(params) => <TextField {...params} fullWidth />}
                                />
                            </Box>
                            <List dense={false}>
                                {
                                    vehicleReports.map((vehicle: object, index: number) => (
                                        <ListItem
                                            key={index}
                                            button
                                            onClick={() => handleVehicleClick(vehicle)}
                                            selected={selectedVehicle?.id === vehicle.id}
                                        >
                                            <ListItemIcon>
                                                <DirectionsBusIcon
                                                    color={'primary'}/>
                                            </ListItemIcon>
                                            <ListItemText
                                                primary={vehicle.vehicle.name}
                                                secondary={`Registration Number: ${vehicle.vehicle.registrationNumber}`}
                                            />
                                        </ListItem>
                                    ))
                                }
                            </List>
                        </Box>
                    </Grid>
                    <Grid item xs={12} md={6}>
                        <Box className="p-4 border rounded shadow">
                            {selectedVehicle ? (
                                <>
                                    <Typography variant="h5" gutterBottom>Vehicle Details</Typography>
                                    <Typography variant="body1"><strong>Name:</strong> {selectedVehicle.vehicle.name}
                                    </Typography>
                                    <Typography
                                        variant="body1"><strong>Registration:</strong> {selectedVehicle.vehicle.registrationNumber}
                                    </Typography>
                                    <Typography variant="body1"><strong>Driver
                                        Name:</strong> {selectedVehicle.driver?.name || 'N/A'}</Typography>
                                    <Typography variant="body1"><strong>Phone
                                        Number:</strong> {selectedVehicle.driver?.phoneNumber || 'N/A'}</Typography>
                                    <br/>
                                    <Typography variant="h6" className="mt-4">Report</Typography>

                                    <List dense={false}>

                                        <ListItem>
                                            <ListItemText
                                                primary={`Damage: ${selectedVehicle.damage}`}
                                            />
                                        </ListItem>

                                        <ListItem>
                                            <ListItemText
                                                primary={`Refueling: ${selectedVehicle.refueling} times`}
                                            />
                                        </ListItem>

                                        <ListItem>
                                            <ListItemText
                                                primary={`Servicing: ${selectedVehicle.servicing}`}
                                            />
                                        </ListItem>


                                    </List>
                                </>
                            ) : (
                                <Typography variant="body1">Select a vehicle to view details and reports.</Typography>
                            )}
                        </Box>
                    </Grid>
                </Grid>

            </div>
        </LocalizationProvider>
    );
}

export default withAdminAuth(Home);
