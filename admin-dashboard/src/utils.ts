import axios from 'axios';
import { jwtDecode } from 'jwt-decode';

export const login = async (username: string, password: string) => {
    const url = process.env.API_URL || 'http://localhost:3000';
    try {
        const response = await axios.post(url + '/api/v1/admin/login', { username, password });
        const { token } = response.data.data;
        localStorage.setItem('token', token);
        return true;
    } catch (error) {
        console.error('Login failed:', error);
        return false;
    }
};


export const isAdmin = (): boolean => {
    const token = localStorage.getItem('token');
    if (!token) return false;

    try {
        const decoded: { role: string } = jwtDecode(token);
        return decoded.role === 'admin';
    } catch (error) {
        console.error('Failed to decode token:', error);
        return false;
    }
};
