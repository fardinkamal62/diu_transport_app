import * as React from 'react';
import {IconButton, Menu, MenuItem} from '@mui/material';
import {Menu as MenuIcon} from '@mui/icons-material';
import Link from "next/link";

export default function NavbarMenu({pages}) {
    const [anchorEl, setAnchorEl] = React.useState(null);
    const open = Boolean(anchorEl);
    const handleClick = (event) => {
        setAnchorEl(event.currentTarget);
    };
    const handleClose = () => {
        setAnchorEl(null);
    };

    return (
        <div className={'flex md:hidden sm:flex'}>
            <IconButton
                aria-label="more"
                id="long-button"
                aria-controls={open ? 'long-menu' : undefined}
                aria-expanded={open ? 'true' : undefined}
                aria-haspopup="true"
                onClick={handleClick}
            >
                <MenuIcon className={'dark:text-white'}/>
            </IconButton>
            <Menu
                id="long-menu"
                MenuListProps={{
                    'aria-labelledby': 'long-button',
                }}
                anchorEl={anchorEl}
                open={open}
                onClose={handleClose}>
                {pages.map((page, index) => (
                    <MenuItem key={index} onClick={handleClose}>
                        <Link href={page.url} key={index}>{page.title}</Link>
                    </MenuItem>
                ))}
            </Menu>
        </div>
    );
}