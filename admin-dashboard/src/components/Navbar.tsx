'use client';

import {AppBar, Box, Container, createTheme, Toolbar} from '@mui/material';
import NavbarMenu from './NavbarMenu';
import Link from "next/link";

const navbarTheme = createTheme({
    components: {
        MuiAppBar: {
            styleOverrides: {
                colorPrimary: {
                    backgroundColor: "rgb(249 250 251)"
                }
            }
        }
    }
});

function NavBar({pages}) {
    return (
        <AppBar position="sticky" className={'bg-gray-50 dark:bg-gray-950 dark:text-black'} sx={{boxShadow: 'none'}}
                theme={navbarTheme}>
            <Container maxWidth="xl">
                <Toolbar className={'text-gray-700 dark:text-gray-400'}>
                    <Link href='/' className={`text-4xl mb-2`}>{'DIU Transport Admin Panel'}</Link>

                    <Box sx={{flexGrow: 100}}></Box>
                    <Box className={'flex sm:hidden md:flex'}>
                        {pages.map((page, index) => (
                            <Link href={page.url} key={index}
                                  className={`text-lg mx-2 decoration-0`}>{page.title}</Link>
                        ))}
                    </Box>
                    {pages.length > 0 && <NavbarMenu pages={pages}/>}
                </Toolbar>
            </Container>
        </AppBar>
    );
}

export default NavBar;
