'use client';

import {useEffect, useState} from 'react';
import withAdminAuth from "@/components/withAdmin";
import {
    Box,
    Button, Checkbox,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    FormControlLabel, FormGroup,
    FormLabel,
    Grid,
    List,
    ListItem,
    ListItemIcon,
    ListItemText,
    Radio,
    RadioGroup,
    TextField,
    Typography
} from '@mui/material';
import DirectionsBusIcon from '@mui/icons-material/DirectionsBus';
import Man3Icon from '@mui/icons-material/Man3';
import RefreshIcon from '@mui/icons-material/Refresh';
import axios from "axios";
import Snackbar, { SnackbarCloseReason } from '@mui/material/Snackbar';
import MuiAlert, { AlertProps } from '@mui/material/Alert';
import React from "react";
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';

import BarikoiMap from "@/components/BarikoiMap";

function Home() {
    const [open, setOpen] = useState(false);
    const [popupType, setPopupType] = useState('');

    const [vehicleId, setVehicleId] = useState('');
    const [driverId, setDriverId] = useState('');
    const [vehicleName, setVehicleName] = useState('');
    const [driverName, setDriverName] = useState('');
    const [vehicleType, setVehicleType] = useState('bus');
    const [vehicleRegistrationNumber, setVehicleRegistrationNumber] = useState('');
    const [driverPhoneNumber, setDriverPhoneNumber] = useState('');
    const [driverPassword, setDriverPassword] = useState('');
    const [vehicleCapacity, setVehicleCapacity] = useState(0);
    const [vehicleReservedSeats, setVehicleReservedSeats] = useState(0);

    const [driverStatus, setDriverStatus] = useState('inactive');
    const [driverPreferredVehicle, setDriverPreferredVehicle] = useState([]);

    const [vehicles, setVehicles] = useState([]);
    const [drivers, setDrivers] = useState([]);
    const [vehicleStatus, setVehicleStatus] = useState('inactive');

    const [isEdit, setIsEdit] = useState(false);

    const [snackbarQueue, setSnackbarQueue] = useState<{ message: string, severity: 'success' | 'error' }[]>([]);
    const [currentSnackbar, setCurrentSnackbar] = useState<{ message: string, severity: 'success' | 'error' } | null>(null);

    const handleSnackbarClose = (event?: React.SyntheticEvent | Event, reason?: SnackbarCloseReason) => {
        if (reason === 'clickaway') {
            return;
        }
        setCurrentSnackbar(null);
        setSnackbarQueue(prevQueue => prevQueue.slice(1));
    };

    useEffect(() => {
        if (!currentSnackbar && snackbarQueue.length > 0) {
            setCurrentSnackbar(snackbarQueue[0]);
        }
    }, [snackbarQueue, currentSnackbar]);

    const showSnackbar = (message: string, severity: 'success' | 'error') => {
        setSnackbarQueue(prevQueue => [...prevQueue, { message, severity }]);
    };

    const Alert = React.forwardRef<HTMLDivElement, AlertProps>(function Alert(
        props,
        ref,
    ) {
        return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
    });


    const url = process.env.API_URL || 'http://localhost:3000';

    const handleClickOpen = (type: string) => {
        setPopupType(type);
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
        setVehicleName('');
        setDriverName('');
        setVehicleType('bus');
        setVehicleRegistrationNumber('');
        setDriverPhoneNumber('');
        setDriverPassword('');
        setVehicleId('');
        setDriverId('');
        setIsEdit(false);
        setVehicleStatus('inactive');
        setDriverStatus('inactive');
        setVehicleCapacity(0);
        setVehicleReservedSeats(0);
        setDriverPreferredVehicle([]);
    };

    const fetchVehicles = () => {
        const endpoint = '/api/v1/vehicles';
        const token = localStorage.getItem('token');

        axios.get(url + endpoint, {
            headers: {
                Authorization: token,
            }
        })
            .then(response => {
                setVehicles(response.data.data);
            })
            .catch(error => {
                showSnackbar('Error fetching vehicle data: ' + error.message, 'error');
                console.error('Error saving vehicles data:', error);
            });
    }

    const fetchDrivers = () => {
        const endpoint = '/api/v1/drivers';
        const token = localStorage.getItem('token');

        axios.get(url + endpoint, {
            headers: {
                Authorization: token,
            }
        })
            .then(response => {
                setDrivers(response.data.data);
            })
            .catch(error => {
                showSnackbar('Error fetching drivers data: ' + error.message, 'error');
                console.error('Error saving drivers data:', error);
            });
    }

    const handleSave = () => {
        handleClose();

        const data = popupType === 'vehicle' ? {
            name: vehicleName,
            type: vehicleType,
            vehicleRegistrationNumber: vehicleRegistrationNumber,
            status: vehicleStatus,
            capacity: vehicleCapacity,
            reservedSeats: vehicleReservedSeats,
        } : {
            name: driverName,
            phoneNumber: driverPhoneNumber,
            password: driverPassword,
            status: driverStatus,
            preferredVehicle: driverPreferredVehicle,
        };

        let endpoint = '';
        if (isEdit) {
            endpoint = popupType === 'vehicle' ? `/api/v1/admin/update-vehicle/${vehicleId}` : `/api/v1/admin/update-driver/${driverId}`;
        } else {
            endpoint = popupType === 'vehicle' ? '/api/v1/admin/add-vehicle' : '/api/v1/admin/add-driver';
        }
        const token = localStorage.getItem('token');

        axios[isEdit ? 'put' : 'post'](url + endpoint, data, {
            headers: {
                Authorization: token,
            }
        })
            .then(() => {
                showSnackbar(`${popupType === 'vehicle' ? 'Vehicle' : 'Driver'} data saved successfully`, 'success');
                setVehicleName('');
                setDriverName('');
                setVehicleType('bus');
                setVehicleRegistrationNumber('');
                setDriverPhoneNumber('');
                setDriverPassword('');
                setIsEdit(false);
                setVehicleId('');
                setDriverId('');
                setVehicleStatus('inactive');
                setDriverStatus('inactive');
                setVehicleCapacity(0);
                setVehicleReservedSeats(0);
                popupType === 'vehicle' ? fetchVehicles() : fetchDrivers();
            })
            .catch(error => {
                showSnackbar('Error saving data: ' + error.message, 'error');
            });
    };

    const handleEdit = (type: string, data: any) => {
        setPopupType(type);
        setIsEdit(true);
        if (type === 'vehicle') {
            setVehicleName(data.name);
            setVehicleType(data.type);
            setVehicleRegistrationNumber(data.vehicleRegistrationNumber);
            setVehicleStatus(data.status);
            setVehicleId(data.id);
            setVehicleCapacity(data.capacity);
            setVehicleReservedSeats(data.reservedSeats);
        } else {
            setDriverName(data.name);
            setDriverPhoneNumber(data.phoneNumber);
            setDriverPassword(data.password);
            setDriverId(data.id);
            setDriverStatus(data.status);
            setDriverPreferredVehicle(data.preferredVehicle);
        }
        setOpen(true);
    };

    const handleDelete = (type: string, id: string) => {
        const endpoint = type === 'vehicle' ? `/api/v1/admin/delete-vehicle/${id}` : `/api/v1/admin/delete-driver/${id}`;
        const token = localStorage.getItem('token');

        axios.delete(url + endpoint, {
            headers: {
                Authorization: token,
            }
        })
            .then(() => {
                showSnackbar(`${type === 'vehicle' ? 'Vehicle' : 'Driver'} deleted successfully`, 'success');
                type === 'vehicle' ? fetchVehicles() : fetchDrivers();
            })
            .catch(error => {
                showSnackbar('Error deleting data: ' + error.message, 'error');
            });
    };

    useEffect(() => {
        fetchVehicles();
        fetchDrivers();
    }, []);

    return (
        <div className="p-4">
            <Typography variant="h4" gutterBottom align="center">
                Welcome, Admin
            </Typography>
            <Grid container spacing={2} justifyContent="center" className='mt-10'>
                <Grid item xs={12} md={6}>
                    <Box className="p-4 border rounded shadow">
                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                            <Typography variant="h5" gutterBottom>Vehicles</Typography>
                            <Button onClick={() => fetchVehicles()}>
                                <RefreshIcon />
                            </Button>
                        </Box>
                        <List dense={false}>
                            {
                                vehicles.map((vehicle: object, index: number) => (
                                    <ListItem key={index}>
                                        <ListItemIcon>
                                            <DirectionsBusIcon
                                                color={vehicle.status === 'active' ? 'primary' : 'error'}/>
                                        </ListItemIcon>
                                        <ListItemText
                                            primary={vehicle.name}
                                            secondary={`Capacity: ${vehicle.capacity}, Reserved Seats: ${vehicle.reservedSeats}`}
                                        />
                                        <Button onClick={() => handleEdit('vehicle', vehicle)}>
                                            <EditIcon />
                                        </Button>
                                        <Button onClick={() => handleDelete('vehicle', vehicle.id)}>
                                            <DeleteIcon color='error'/>
                                        </Button>
                                    </ListItem>
                                ))
                            }
                        </List>
                        <Button variant="contained" color="primary" onClick={() => handleClickOpen('vehicle')}>
                            Add Vehicle
                        </Button>
                    </Box>
                </Grid>
                <Grid item xs={12} md={6}>
                    <Box className="p-4 border rounded shadow">
                        <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                            <Typography variant="h5" gutterBottom>Drivers</Typography>
                            <Button onClick={() => fetchDrivers()}>
                                <RefreshIcon />
                            </Button>
                        </Box>
                        <List dense={false}>
                            {
                                drivers.map((driver: object, index: number) => (
                                    <ListItem key={index}>
                                        <ListItemIcon>
                                            <Man3Icon color={driver.status === 'active' ? 'primary' : 'error'}/>
                                        </ListItemIcon>
                                        <ListItemText
                                            primary={driver.name}
                                            secondary={`Phone Number: ${driver.phoneNumber}`}
                                        />
                                        <Button onClick={() => handleEdit('driver', driver)}>
                                            <EditIcon />
                                        </Button>
                                        <Button onClick={() => handleDelete('driver', driver.id)}>
                                            <DeleteIcon color='error'/>
                                        </Button>
                                    </ListItem>
                                ))
                            }
                        </List>
                        <Button variant="contained" color="primary" onClick={() => handleClickOpen('driver')}>
                            Add Driver
                        </Button>
                    </Box>
                </Grid>
            </Grid>
            <Dialog open={open} onClose={handleClose}>
                <DialogTitle>{popupType === 'vehicle' ? 'Add Vehicle' : 'Add Driver'}</DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        label={popupType === 'vehicle' ? 'Vehicle Name' : 'Driver Name'}
                        fullWidth
                        variant="standard"
                        onChange={popupType === 'vehicle' ? (e) => setVehicleName(e.target.value) : (e) => setDriverName(e.target.value)}
                        value={popupType === 'vehicle' ? vehicleName : driverName}
                    />
                    {popupType === 'vehicle' ? (
                        <>
                            <FormLabel id="demo-radio-buttons-group-label">Vehicle Type</FormLabel>
                            <RadioGroup
                                aria-labelledby="demo-radio-buttons-group-label"
                                defaultValue="bus"
                                name="radio-buttons-group"
                                onChange={(e) => setVehicleType(e.target.value)}
                                value={vehicleType}
                            >
                                <FormControlLabel value="bus" control={<Radio/>} label="Bus"/>
                                <FormControlLabel value="microbus" control={<Radio/>} label="Microbus"/>
                            </RadioGroup>
                            <TextField
                                margin="dense"
                                label="Vehicle Registration Number"
                                fullWidth
                                variant="standard"
                                onChange={(e) => setVehicleRegistrationNumber(e.target.value)}
                                value={vehicleRegistrationNumber}
                            />
                            <FormLabel id="demo-radio-buttons-group-label">Vehicle Status</FormLabel>
                            <RadioGroup
                                aria-labelledby="demo-radio-buttons-group-label"
                                defaultValue="inactive"
                                name="radio-buttons-group"
                                onChange={(e) => setVehicleStatus(e.target.value)}
                                value={vehicleStatus}
                            >
                                <FormControlLabel value="active" control={<Radio/>} label="Active"/>
                                <FormControlLabel value="inactive" control={<Radio/>} label="Inactive"/>
                            </RadioGroup>
                            <TextField
                                margin="dense"
                                label="Vehicle Capacity"
                                fullWidth
                                variant="standard"
                                type="number"
                                onChange={(e) => setVehicleCapacity(Number(e.target.value))}
                                value={vehicleCapacity}
                            />
                            <TextField
                                margin="dense"
                                label="Reserved Seats"
                                fullWidth
                                variant="standard"
                                type="number"
                                onChange={(e) => setVehicleReservedSeats(Number(e.target.value))}
                                value={vehicleReservedSeats}
                            />
                        </>
                    ) : (
                        <>
                            <TextField
                                margin="dense"
                                label="Driver Phone Number"
                                fullWidth
                                variant="standard"
                                onChange={(e) => setDriverPhoneNumber(e.target.value)}
                                value={driverPhoneNumber}
                            />
                            <TextField
                                margin="dense"
                                label="Driver Password"
                                fullWidth
                                variant="standard"
                                type="password"
                                onChange={(e) => setDriverPassword(e.target.value)}
                                value={driverPassword}
                            />
                            <FormLabel id="demo-radio-buttons-group-label">Driver Status</FormLabel>
                            <RadioGroup
                                aria-labelledby="demo-radio-buttons-group-label"
                                defaultValue="inactive"
                                name="radio-buttons-group"
                                onChange={(e) => setDriverStatus(e.target.value)}
                                value={driverStatus}
                            >
                                <FormControlLabel value="active" control={<Radio/>} label="Active"/>
                                <FormControlLabel value="inactive" control={<Radio/>} label="Inactive"/>
                            </RadioGroup>
                            <FormLabel id="demo-radio-buttons-group-label">Preferred Vehicle</FormLabel>
                            <FormGroup>
                                <FormControlLabel
                                    control={<Checkbox checked={driverPreferredVehicle.includes('bus')} onChange={(e) => {
                                        if (e.target.checked) {
                                            setDriverPreferredVehicle([...driverPreferredVehicle, 'bus']);
                                        } else {
                                            setDriverPreferredVehicle(driverPreferredVehicle.filter((vehicle) => vehicle !== 'bus'));
                                        }
                                    }} />}
                                    label="Bus"
                                />
                                <FormControlLabel
                                    control={<Checkbox checked={driverPreferredVehicle.includes('microbus')} onChange={(e) => {
                                        if (e.target.checked) {
                                            setDriverPreferredVehicle([...driverPreferredVehicle, 'microbus']);
                                        } else {
                                            setDriverPreferredVehicle(driverPreferredVehicle.filter((vehicle) => vehicle !== 'microbus'));
                                        }
                                    }} />}
                                    label="Microbus"
                                />
                            </FormGroup>
                        </>
                    )}
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleClose} color="primary">
                        Cancel
                    </Button>
                    <Button onClick={handleSave} color="primary">
                        Save
                    </Button>
                </DialogActions>
            </Dialog>
            <div className='mt-16'>
                <Typography
                    variant="h4"
                    gutterBottom
                    align="center"
                    className="mt-10">
                    Vehicle Location
                </Typography>
                <div>
                    <BarikoiMap/>
                </div>
            </div>
            {
                currentSnackbar && <Snackbar open={!!currentSnackbar} autoHideDuration={5000} onClose={handleSnackbarClose}>
                    <Alert onClose={handleSnackbarClose} severity={currentSnackbar.severity} sx={{ width: '100%' }}>
                        {currentSnackbar.message}
                    </Alert>
                </Snackbar>
            }
        </div>
    );
}

export default withAdminAuth(Home);
