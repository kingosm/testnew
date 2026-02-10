import { useState, useCallback, useEffect } from "react";
import { useLanguage } from "@/contexts/LanguageContext";

export interface LocationState {
    lat: number;
    lon: number;
}

export function calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
): number {
    const R = 6371; // Earth's radius in km
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLon = ((lon2 - lon1) * Math.PI) / 180;
    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
}

export const useLocation = () => {
    const { t } = useLanguage();
    const [userLocation, setUserLocation] = useState<LocationState | null>(null);
    const [isLoadingLocation, setIsLoadingLocation] = useState(false);
    const [locationError, setLocationError] = useState<string | null>(null);

    const requestLocation = useCallback((highAccuracy = true) => {
        setIsLoadingLocation(true);
        setLocationError(null);

        if (!navigator.geolocation) {
            setLocationError(t('error.geo.unsupported'));
            setIsLoadingLocation(false);
            return;
        }

        const options = {
            enableHighAccuracy: highAccuracy,
            timeout: highAccuracy ? 10000 : 15000,
            maximumAge: 0,
        };

        navigator.geolocation.getCurrentPosition(
            (position) => {
                setUserLocation({
                    lat: position.coords.latitude,
                    lon: position.coords.longitude,
                });
                setIsLoadingLocation(false);
            },
            (error) => {
                console.error("Geolocation error:", error);

                if (highAccuracy && (error.code === error.TIMEOUT || error.code === error.POSITION_UNAVAILABLE)) {
                    console.log("High accuracy failed, retrying with lower accuracy...");
                    requestLocation(false);
                    return;
                }

                let errorKey = 'nearby.error';
                if (error.code === error.PERMISSION_DENIED) {
                    errorKey = 'nearby.error.denied';
                } else if (error.code === error.TIMEOUT) {
                    errorKey = 'nearby.error.timeout';
                }

                setLocationError(t(errorKey));
                setIsLoadingLocation(false);
            },
            options
        );
    }, [t]);

    // Try to get location on mount if possible (cached)
    useEffect(() => {
        if (navigator.geolocation) {
            // Check for permission first if possible, or just try a silent low-accuracy check
            // For now, let's just let the user trigger it for better UX (no sudden popups)
        }
    }, []);

    return {
        userLocation,
        isLoadingLocation,
        locationError,
        requestLocation,
        calculateDistance
    };
};
