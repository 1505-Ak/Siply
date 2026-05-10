import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React, { useEffect, useRef, useState } from 'react';
import { StatusBar, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import MapView, { Marker } from 'react-native-maps';
import { SafeAreaView } from 'react-native-safe-area-context';
import { CitySelectModal } from '../components/FindComponents/CitySelectModal';
import { VenueListModal } from '../components/FindComponents/VenueListModal';
import { findService } from '../services/find.service';

const MAP_STYLE = [
  { "elementType": "geometry", "stylers": [{ "color": "#242f3e" }] },
  { "elementType": "labels.text.fill", "stylers": [{ "color": "#746855" }] },
  { "elementType": "labels.text.stroke", "stylers": [{ "color": "#242f3e" }] },
  { "featureType": "road", "elementType": "geometry", "stylers": [{ "color": "#38414e" }] },
  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#17263c" }] }
];

const FindScreen = () => {
  const mapRef = useRef<MapView>(null);
  const [cities, setCities] = useState<any[]>([]);
  const [venues, setVenues] = useState<any[]>([]);
  const [selectedCity, setSelectedCity] = useState<any>(null);
  
  const [cityModalVisible, setCityModalVisible] = useState(false);
  const [venueModalVisible, setVenueModalVisible] = useState(false);

  useEffect(() => {
    findService.getCities().then((res) => {
        setCities(res);
        setSelectedCity(res[0]); // London default
    });
  }, []);

  const handleCitySelect = async (city: any) => {
    setSelectedCity(city);
    const cityVenues = await findService.getVenuesByCity(city.id);
    setVenues(cityVenues);
    setCityModalVisible(false);
    setVenueModalVisible(true); // Automatically show venues for that city
  };

  const handleVenueSelect = (venue: any) => {
    setVenueModalVisible(false);
    // Zoom to venue
    mapRef.current?.animateToRegion({
      ...venue.coordinates,
      latitudeDelta: 0.01,
      longitudeDelta: 0.01,
    }, 1000);
  };

  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <StatusBar barStyle="light-content" />
      
      <MapView
        ref={mapRef}
        style={StyleSheet.absoluteFillObject}
        customMapStyle={MAP_STYLE}
        initialRegion={{
          latitude: 51.5074,
          longitude: -0.1278,
          latitudeDelta: 0.05,
          longitudeDelta: 0.05,
        }}
      >
        {venues.map((v) => (
          <Marker key={v.id} coordinate={v.coordinates}>
            <View className="bg-siplyLime p-2 rounded-full border-2 border-white shadow-xl">
               <MaterialCommunityIcons name={v.icon} size={18} color="black" />
            </View>
          </Marker>
        ))}
      </MapView>

      {/* Top Location Dropdown */}
      <SafeAreaView className="absolute top-0 left-0 right-0 px-6 py-2">
        <TouchableOpacity 
          onPress={() => setCityModalVisible(true)}
          className="bg-siplyLime self-start flex-row items-center px-4 py-2.5 rounded-full shadow-lg"
        >
          <View className="w-5 h-5 bg-black/10 rounded-full items-center justify-center mr-2">
            <Ionicons name="location" size={12} color="black" />
          </View>
          <Text className="text-black font-bold text-base">{selectedCity?.name || 'London, UK'}</Text>
          <Ionicons name="chevron-down" size={16} color="black" className="ml-1" />
        </TouchableOpacity>
      </SafeAreaView>

      {/* Floating Action Buttons */}
      <View style={{ bottom: 120 }} className="absolute right-6 gap-4">
        <TouchableOpacity className="bg-siplyLime w-14 h-14 rounded-full items-center justify-center shadow-xl">
          <MaterialCommunityIcons name="target" size={26} color="black" />
        </TouchableOpacity>
        <TouchableOpacity 
          onPress={() => setVenueModalVisible(true)}
          className="bg-siplyLime w-14 h-14 rounded-full items-center justify-center shadow-xl"
        >
          <Ionicons name="list" size={26} color="black" />
        </TouchableOpacity>
        <TouchableOpacity className="bg-siplyLime w-14 h-14 rounded-full items-center justify-center shadow-xl">
          <Ionicons name="information-circle" size={28} color="black" />
        </TouchableOpacity>
      </View>

      {/* MODALS */}
      <CitySelectModal 
        visible={cityModalVisible} 
        onClose={() => setCityModalVisible(false)} 
        onSelect={handleCitySelect}
        cities={cities}
        selectedCityId={selectedCity?.id}
      />

      <VenueListModal 
        visible={venueModalVisible} 
        onClose={() => setVenueModalVisible(false)} 
        onSelect={handleVenueSelect}
        venues={venues}
      />
    </View>
  );
};

export default FindScreen;