'use client';

import {useEffect, useState} from 'react';
import withAdminAuth from "@/components/withAdmin";
import {
    Box,
    Button,
    Dialog,
    DialogActions,
    DialogContent,
    DialogTitle,
    FormControlLabel,
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
import axios from "axios";

import BarikoiMap from "@/components/BarikoiMap";

function Home() {
    const [open, setOpen] = useState(false);
    const [popupType, setPopupType] = useState('');
    const [vehicleName, setVehicleName] = useState('');
    const [driverName, setDriverName] = useState('');
    const [vehicleType, setVehicleType] = useState('bus');
    const [vehicleRegistrationNumber, setVehicleRegistrationNumber] = useState('');
    const [driverPhoneNumber, setDriverPhoneNumber] = useState('');
    const [driverPassword, setDriverPassword] = useState('');

    const [vehicles, setVehicles] = useState([]);
    const [drivers, setDrivers] = useState([]);

    const url = process.env.API_URL || 'http://localhost:3000';

    const handleClickOpen = (type: string) => {
        setPopupType(type);
        setOpen(true);
    };

    const handleClose = () => {
        setOpen(false);
    };

    const handleSave = () => {
        // Handle save logic here
        handleClose();

        const data = popupType === 'vehicle' ? {
            name: vehicleName,
            type: vehicleType,
            vehicleRegistrationNumber: vehicleRegistrationNumber
        } : {
            name: driverName,
            phoneNumber: driverPhoneNumber,
            password: driverPassword
        };

        const endpoint = popupType === 'vehicle' ? '/api/v1/admin/add-vehicle' : '/api/v1/admin/add-driver';
        const token = localStorage.getItem('token');

        axios.post(url + endpoint, data, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        })
            .then(response => {
                console.log('Data saved successfully:', response.data);
            })
            .catch(error => {
                console.error('Error saving data:', error);
            });
    };

    const fetchVehicles = () => {
        const endpoint = '/api/v1/vehicles';
        const token = localStorage.getItem('token');

        axios.get(url + endpoint, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        })
            .then(response => {
                console.log('Data saved successfully:', response.data);
                setVehicles(response.data.data);
            })
            .catch(error => {
                console.error('Error saving data:', error);
            });
    }

    const fetchDrivers = () => {
        const endpoint = '/api/v1/drivers';
        const token = localStorage.getItem('token');

        axios.get(url + endpoint, {
            headers: {
                Authorization: `Bearer ${token}`,
            }
        })
            .then(response => {
                console.log('Data saved successfully:', response.data);
                setDrivers(response.data.data);
            })
            .catch(error => {
                console.error('Error saving data:', error);
            });
    }

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
                        <Typography variant="h6" gutterBottom>
                            Vehicles
                        </Typography>
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
                                            secondary={`Type: ${vehicle.type}, Registration Number: ${vehicle.vehicleRegistrationNumber}`}
                                        />
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
                        <Typography variant="h6" gutterBottom>
                            Drivers
                        </Typography>
                        <List dense={false}>
                            {
                                drivers.map((driver: object, index: number) => (
                                    <ListItem key={index}>
                                        <ListItemIcon>
                                            <Man3Icon color="primary"/>
                                        </ListItemIcon>
                                        <ListItemText
                                            primary={driver.name}
                                            secondary={`Phone Number: ${driver.phoneNumber}`}
                                        />
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
                    />
                    {popupType === 'vehicle' ? (
                        <>
                            <FormLabel id="demo-radio-buttons-group-label">Vehicle Type</FormLabel>
                            <RadioGroup
                                aria-labelledby="demo-radio-buttons-group-label"
                                defaultValue="bus"
                                name="radio-buttons-group"
                                onChange={(e) => setVehicleType(e.target.value)}
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
                            />
                            <TextField
                                margin="dense"
                                label="Driver Password"
                                fullWidth
                                variant="standard"
                                type="password"
                                onChange={(e) => setDriverPassword(e.target.value)}
                            />
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
        </div>
    );
}

export default withAdminAuth(Home);
