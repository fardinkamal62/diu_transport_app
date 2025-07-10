'use client';

import {useEffect, useState} from 'react';
import withAdminAuth from "@/components/withAdmin";
import {
    Box,
    Button,
    Grid,
    List,
    TextField,
    Typography
} from '@mui/material';
import RefreshIcon from '@mui/icons-material/Refresh';
import axios from "axios";
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

    const [statistics, setStatistics] = useState({
        totalTrips: 0,
        vehicleReports: [],
        driverReports: []
    });
    const [selectedStartDate, setSelectedStartDate] = useState<Date | null>(null);
    const [selectedEndDate, setSelectedEndDate] = useState<Date | null>(null);

    useEffect(() => {
        if (!currentSnackbar && snackbarQueue.length > 0) {
            setCurrentSnackbar(snackbarQueue[0]);
        }
    }, [snackbarQueue, currentSnackbar]);

    const showSnackbar = (message: string, severity: 'success' | 'error') => {
        setSnackbarQueue(prevQueue => [...prevQueue, {message, severity}]);
    };

    const url = process.env.API_URL || 'http://localhost:3000';

    const fetchStats = () => {
        if (!selectedStartDate || !selectedEndDate) {
            return;
        }

        const endpoint = `/api/v1/admin/statistics?startTime=${selectedStartDate.toISOString()}&endTime=${selectedEndDate.toISOString()}`;
        const token = localStorage.getItem('token');

        axios.get(url + endpoint, {
            headers: {
                Authorization: token,
            }
        })
            .then(response => {
                setStatistics(response.data.data);
            })
            .catch(error => {
                showSnackbar('Error fetching statistics: ' + error.message, 'error');
                console.error('Error fetching statistics:', error);
            });
    };

    const handleDateChange = (date: Date | null, isStartDate: boolean) => {
        if (isStartDate) {
            setSelectedStartDate(date);
        } else {
            setSelectedEndDate(date);
        }

        if (selectedStartDate && selectedEndDate) {
            fetchStats(date);
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
        fetchStats();
        setSelectedStartDate(new Date());
        setSelectedEndDate(new Date());
    }, []);

    const navbarPages = [
        {title: 'Home', url: '/'},
    ];

    return (
        <LocalizationProvider dateAdapter={AdapterDateFns}>
            <NavBar pages={navbarPages} title={'Statistics'}/>
            <div className="p-4">
                <Grid container spacing={2} justifyContent="center" className='mt-10'>
                    <Grid item xs={12} md={6}>
                        <Box display="flex" alignItems="center">
                            <DatePicker
                                label="Start Date"
                                value={selectedStartDate}
                                onChange={(date) => handleDateChange(date, true)}
                                renderInput={(params) => <TextField {...params} fullWidth />}
                            />
                            <Box sx={{ mx: 2 }}>to</Box>
                            <DatePicker
                                label="End Date"
                                value={selectedEndDate}
                                onChange={(date) => handleDateChange(date, false)}
                                renderInput={(params) => <TextField {...params} fullWidth />}
                            />
                        </Box>

                        <Box className="p-4 border rounded shadow mt-4">
                            <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                                <Typography variant="h5" gutterBottom>Statistics</Typography>
                                <Button onClick={() => fetchStats()}>
                                    <RefreshIcon/>
                                </Button>
                            </Box>
                                <List dense={false}>
                                <Typography variant="h6" gutterBottom>Total Trips: {statistics.totalTrips}</Typography>
                                <Box mt={5}/>
                                <Typography variant="h4" gutterBottom>Trips by Vehicle</Typography>
                                { statistics && statistics.vehicleReports && statistics.vehicleReports.length > 0 ?
                                    statistics.vehicleReports.map((report: any, index: number) => (
                                        <Typography key={index} variant="body1">
                                            {report.vehicleName} ({report.vehicleRegistrationNumber}): {report.tripCount} trips
                                        </Typography>
                                    )) : <Typography variant="body1">No vehicle reports available</Typography>
                                }
                                <Box mt={5}/>
                                <Typography variant="h4" gutterBottom>Trips by Driver</Typography>
                                {
                                    statistics && statistics.driverReports && statistics.driverReports.length > 0 ?
                                    statistics.driverReports.map((report: any, index: number) => (
                                        <Typography key={index} variant="body1">
                                            {report.driverName} ({report.phoneNumber}): {report.tripCount} trips
                                        </Typography>
                                    )) : <Typography variant="body1">No driver reports available</Typography>
                                }
                            </List>
                        </Box>
                    </Grid>
                </Grid>

            </div>
        </LocalizationProvider>
    );
}

export default withAdminAuth(Home);
