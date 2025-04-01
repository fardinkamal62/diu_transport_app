"use client";
import { useEffect, useRef, useState } from "react";
import { Map, Marker } from "bkoi-gl";
import "bkoi-gl/dist/style/bkoi-gl.css";

import {socket} from "@/socket";

function MainMap() {
    const mapContainer = useRef<HTMLDivElement>(null);
    const mapRef = useRef<any>(null);
    const [markers, setMarkers] = useState<{ [id: string]: Marker }>({});

    useEffect(() => {
        if (!mapRef.current) {
            mapRef.current = new Map({
                container: mapContainer.current!,
                center: [90.4470, 23.7942],
                zoom: 16,
                accessToken: process.env.NEXT_PUBLIC_BARIKOI_API_KEY,
            });
        }

        const handleLocation = (data: any) => {
            const lat = parseFloat(data.latitude);
            const lng = parseFloat(data.longitude);
            setMarkers((prev) => {
                const existingMarker = prev[data.vehicleId];
                if (existingMarker) {
                    existingMarker.setLngLat([lng, lat]);
                    return prev;
                }

                // Create container element
                const containerEl = document.createElement("div");
                containerEl.style.display = "flex";
                containerEl.style.alignItems = "center";

                // Create icon element
                const iconEl = document.createElement("img");
                iconEl.src = "https://img.icons8.com/ios/50/bus.png"; // Replace with your icon path
                iconEl.style.width = "24px";
                iconEl.style.height = "24px";
                iconEl.style.marginRight = "4px";

                // Create label element
                const labelEl = document.createElement("div");
                labelEl.innerText = data.vehicleId;
                labelEl.style.padding = "4px";
                labelEl.style.borderRadius = "4px";
                labelEl.style.color = "black";

                // Append icon and label to container
                containerEl.appendChild(iconEl);
                containerEl.appendChild(labelEl);

                const newMarker = new Marker({ element: containerEl }).setLngLat([lng, lat]).addTo(mapRef.current);
                return { ...prev, [data.vehicleId]: newMarker };
            });
        };

        socket.on("location", handleLocation);
        return () => {
            socket.off("location", handleLocation);
        };
    }, []);

    return <div ref={mapContainer} style={containerStyles} />;
}


// JSX Styles
const containerStyles = {
    width: "70%",
    height: "10vh",
    minHeight: "400px",
    overflow: "hidden",
    margin: "0 auto", // center horizontally
};

export default MainMap;
