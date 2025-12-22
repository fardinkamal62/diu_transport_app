'use client';

import { useEffect, useState } from 'react';
import withAdminAuth from "@/components/withAdmin";
import {
    Box,
    Button,
    Checkbox,
    FormControlLabel,
    IconButton,
    Paper,
    Stack,
    Switch,
    TextField,
    Typography,
    Alert,
    Snackbar
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';
import SaveIcon from '@mui/icons-material/Save';
import axios from "axios";
import NavBar from '@/components/Navbar';

const DAY_NAMES = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

function SettingsPage() {
    const url = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';
    
    const [reservationEnabled, setReservationEnabled] = useState(true);
    const [maxAdvanceBookingDays, setMaxAdvanceBookingDays] = useState(7);
    const [reservationWindows, setReservationWindows] = useState<Record<string, { enabled: boolean; windows: { start: string; end: string }[] }>>({});
    
    const [snackbarOpen, setSnackbarOpen] = useState(false);
    const [snackbarMessage, setSnackbarMessage] = useState('');
    const [snackbarSeverity, setSnackbarSeverity] = useState<'success' | 'error'>('success');
    const [loading, setLoading] = useState(false);

    const pages = [
        { title: 'Vehicles & Drivers', url: '/' },
        { title: 'Statistics', url: '/statistics' },
        { title: 'Vehicle Report', url: '/vehicle_report' },
        { title: 'Settings', url: '/settings' },
    ];

    useEffect(() => {
        fetchSettings();
    }, []);

    const fetchSettings = async () => {
        try {
            const token = localStorage.getItem('token');
            const response = await axios.get(`${url}/api/v1/admin/system-settings`, {
                headers: { Authorization: `${token}` }
            });
            
            const data = response.data.data;
            setReservationEnabled(data.reservationEnabled);
            setMaxAdvanceBookingDays(data.maxAdvanceBookingDays);
            
            // Convert Map to object if needed
            const windows = data.reservationWindows instanceof Map 
                ? Object.fromEntries(data.reservationWindows)
                : data.reservationWindows;
            
            setReservationWindows(windows || {});
        } catch (error: any) {
            showSnackbar('Failed to fetch settings: ' + (error.response?.data?.error || error.message), 'error');
        }
    };

    const handleSaveSettings = async () => {
        setLoading(true);
        try {
            const token = localStorage.getItem('token');
            await axios.put(`${url}/api/v1/admin/system-settings`, {
                reservationEnabled,
                maxAdvanceBookingDays,
                reservationWindows
            }, {
                headers: { Authorization: `${token}` }
            });
            
            showSnackbar('Settings saved successfully!', 'success');
        } catch (error: any) {
            showSnackbar('Failed to save settings: ' + (error.response?.data?.error || error.message), 'error');
        } finally {
            setLoading(false);
        }
    };

    const showSnackbar = (message: string, severity: 'success' | 'error') => {
        setSnackbarMessage(message);
        setSnackbarSeverity(severity);
        setSnackbarOpen(true);
    };

    const handleDayToggle = (dayIndex: number) => {
        const dayKey = dayIndex.toString();
        setReservationWindows(prev => ({
            ...prev,
            [dayKey]: {
                enabled: !prev[dayKey]?.enabled,
                windows: prev[dayKey]?.windows || []
            }
        }));
    };

    const handleAddTimeWindow = (dayIndex: number) => {
        const dayKey = dayIndex.toString();
        setReservationWindows(prev => ({
            ...prev,
            [dayKey]: {
                enabled: prev[dayKey]?.enabled ?? true,
                windows: [...(prev[dayKey]?.windows || []), { start: '09:00', end: '17:00' }]
            }
        }));
    };

    const handleRemoveTimeWindow = (dayIndex: number, windowIndex: number) => {
        const dayKey = dayIndex.toString();
        setReservationWindows(prev => ({
            ...prev,
            [dayKey]: {
                ...prev[dayKey],
                windows: prev[dayKey].windows.filter((_, i) => i !== windowIndex)
            }
        }));
    };

    const handleTimeChange = (dayIndex: number, windowIndex: number, field: 'start' | 'end', value: string) => {
        const dayKey = dayIndex.toString();
        setReservationWindows(prev => ({
            ...prev,
            [dayKey]: {
                ...prev[dayKey],
                windows: prev[dayKey].windows.map((window, i) => 
                    i === windowIndex ? { ...window, [field]: value } : window
                )
            }
        }));
    };

    return (
        <div>
            <NavBar pages={pages} title='DIU Transport - Settings' />
            
            <Box sx={{ p: 4 }}>
                <Typography variant="h4" gutterBottom>
                    System Settings
                </Typography>

                <Stack spacing={3}>
                    {/* Global Settings */}
                    <Box sx={{ maxWidth: 600 }}>
                        <Paper sx={{ p: 3 }}>
                            <Typography variant="h6" gutterBottom>
                                Global Settings
                            </Typography>
                            
                            <FormControlLabel
                                control={
                                    <Switch 
                                        checked={reservationEnabled}
                                        onChange={(e) => setReservationEnabled(e.target.checked)}
                                    />
                                }
                                label="Reservation System Enabled"
                            />
                            
                            <TextField
                                label="Max Advance Booking Days"
                                type="number"
                                fullWidth
                                margin="normal"
                                value={maxAdvanceBookingDays}
                                onChange={(e) => setMaxAdvanceBookingDays(parseInt(e.target.value) || 1)}
                                inputProps={{ min: 1, max: 30 }}
                                helperText="How many days in advance can users book?"
                            />
                        </Paper>
                    </Box>

                    {/* Day-Specific Reservation Windows */}
                    <Paper sx={{ p: 3 }}>
                            <Typography variant="h6" gutterBottom>
                                Reservation Time Windows by Day
                            </Typography>
                            <Typography variant="body2" color="text.secondary" gutterBottom>
                                Configure when users can make reservations on each day of the week
                            </Typography>

                            {DAY_NAMES.map((dayName, dayIndex) => {
                                const dayKey = dayIndex.toString();
                                const daySettings = reservationWindows[dayKey] || { enabled: false, windows: [] };

                                return (
                                    <Box key={dayIndex} sx={{ mb: 3, mt: 2, p: 2, border: '1px solid #e0e0e0', borderRadius: 2 }}>
                                        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1 }}>
                                            <FormControlLabel
                                                control={
                                                    <Checkbox
                                                        checked={daySettings.enabled}
                                                        onChange={() => handleDayToggle(dayIndex)}
                                                    />
                                                }
                                                label={<Typography variant="subtitle1" fontWeight="bold">{dayName}</Typography>}
                                            />
                                            
                                            {daySettings.enabled && (
                                                <Button
                                                    size="small"
                                                    startIcon={<AddIcon />}
                                                    onClick={() => handleAddTimeWindow(dayIndex)}
                                                    variant="outlined"
                                                >
                                                    Add Time Window
                                                </Button>
                                            )}
                                        </Box>

                                        {daySettings.enabled && daySettings.windows.length === 0 && (
                                            <Alert severity="warning" sx={{ mt: 1 }}>
                                                No time windows configured. Click "Add Time Window" to add one.
                                            </Alert>
                                        )}

                                        {daySettings.enabled && daySettings.windows.map((window, windowIndex) => (
                                            <Box key={windowIndex} sx={{ display: 'flex', alignItems: 'center', gap: 2, mt: 1 }}>
                                                <TextField
                                                    label="Start Time"
                                                    type="time"
                                                    value={window.start}
                                                    onChange={(e) => handleTimeChange(dayIndex, windowIndex, 'start', e.target.value)}
                                                    InputLabelProps={{ shrink: true }}
                                                    inputProps={{ step: 300 }}
                                                    size="small"
                                                />
                                                <Typography>to</Typography>
                                                <TextField
                                                    label="End Time"
                                                    type="time"
                                                    value={window.end}
                                                    onChange={(e) => handleTimeChange(dayIndex, windowIndex, 'end', e.target.value)}
                                                    InputLabelProps={{ shrink: true }}
                                                    inputProps={{ step: 300 }}
                                                    size="small"
                                                />
                                                <IconButton
                                                    color="error"
                                                    onClick={() => handleRemoveTimeWindow(dayIndex, windowIndex)}
                                                    size="small"
                                                >
                                                    <DeleteIcon />
                                                </IconButton>
                                            </Box>
                                        ))}
                                    </Box>
                                );
                            })}
                        </Paper>

                    {/* Save Button */}
                    <Box>
                        <Button
                            variant="contained"
                            color="primary"
                            size="large"
                            startIcon={<SaveIcon />}
                            onClick={handleSaveSettings}
                            disabled={loading}
                        >
                            {loading ? 'Saving...' : 'Save Settings'}
                        </Button>
                    </Box>
                </Stack>
            </Box>

            <Snackbar
                open={snackbarOpen}
                autoHideDuration={6000}
                onClose={() => setSnackbarOpen(false)}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
            >
                <Alert onClose={() => setSnackbarOpen(false)} severity={snackbarSeverity}>
                    {snackbarMessage}
                </Alert>
            </Snackbar>
        </div>
    );
}

export default withAdminAuth(SettingsPage);
