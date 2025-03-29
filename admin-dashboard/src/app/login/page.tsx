'use client';

import Image from 'next/image';
import React, {useState} from "react";
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import VisibilityIcon from '@mui/icons-material/Visibility';
import {login} from '@/utils';

export default function Home() {
    const [showPassword, setShowPassword] = useState(false)
    const [password, setPassword] = useState('')

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        const success = await login('admin', password);
        if (success) {
            window.location.href = '/';
        } else {
            alert('Login failed. Please check your credentials.');
        }
    }

    return (
        <div className="min-h-screen bg-gray-100 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
            <div className="sm:mx-auto sm:w-full sm:max-w-md">
                <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
                    <div className={'flex justify-center mb-5'}>
                        <Image src="/logo.jpeg" alt="DIU Transport Logo" width={100} height={100}
                               className={'rounded-full aspect-square object-cover'}/>
                    </div>
                    Admin Login
                </h2>
            </div>

            <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
                <div className="bg-card text-card-foreground py-8 px-4 shadow sm:rounded-lg sm:px-10">
                    <form className="space-y-6" onSubmit={handleSubmit}>
                        <div>
                            <label htmlFor="password"
                                   className="block text-sm font-medium text-card-foreground text-black">
                                Password
                            </label>
                            <div className="mt-1 relative text-gray-500 focus-within:text-gray-900">
                                <input
                                    id="password"
                                    name="password"
                                    type={showPassword ? 'text' : 'password'}
                                    autoComplete="current-password"
                                    required
                                    className="appearance-none block w-full px-3 py-2 border border-muted rounded-md shadow-sm placeholder-muted-foreground focus:outline-none focus:ring-primary focus:border-primary sm:text-sm"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                />
                                <button
                                    type="button"
                                    className="absolute inset-y-0 right-0 pr-3 flex items-center text-muted-foreground"
                                    onClick={() => setShowPassword(!showPassword)}
                                >
                                    {showPassword ? (
                                        <VisibilityOffIcon className="h-5 w-5" aria-hidden="true"/>
                                    ) : (
                                        <VisibilityIcon className="h-5 w-5" aria-hidden="true"/>
                                    )}
                                </button>
                            </div>
                        </div>

                        <div>
                            <button
                                type="submit"
                                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-primary-foreground bg-blue-400 hover:bg-blue-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary hover:cursor-pointer"
                            >
                                    Sign in
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}
