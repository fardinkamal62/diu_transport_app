"use client";

import React, {useEffect, useState} from 'react';
import {useRouter} from 'next/navigation';

import {isAdmin} from '@/utils';
import {Dialog, DialogActions, DialogTitle} from "@mui/material";

const withAdminAuth = (WrappedComponent: React.ComponentType) => {
    const WithAdminAuth = (props: any) => {
        const router = useRouter();
        const [open, setOpen] = useState(false);
        const [isAuthorized, setIsAuthorized] = useState(false);

        useEffect(() => {
            if (!isAdmin()) {
                setOpen(true);
            } else {
                setIsAuthorized(true);
            }
        }, []);

        const handleClose = () => {
            setOpen(false);
            router.replace('/login');
        };

        if (!isAuthorized) {
            return (
                <Dialog open={open} onClose={handleClose}>
                    <DialogTitle className="font-bold text-red-500">
                        Page Restricted
                    </DialogTitle>
                    <DialogActions>
                        <button onClick={handleClose} className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-primary-foreground bg-blue-400 hover:bg-blue-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary hover:cursor-pointer">Sign in</button>
                    </DialogActions>
                </Dialog>
            );
        }

        return <WrappedComponent {...props} />;
    };

    WithAdminAuth.displayName = `WithAdminAuth(${WrappedComponent.displayName || WrappedComponent.name || 'Component'})`;

    return WithAdminAuth;
};

export default withAdminAuth;
