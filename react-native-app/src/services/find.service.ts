export const findService = {
  getMapVenues: async () => {
    return [
      {
        id: 'v1',
        name: 'Espresso Martini',
        venue: 'The Cocktail Bar',
        coordinates: { latitude: 51.5048, longitude: -0.1235 },
        icon: 'glass-cocktail',
        isHighlighted: true
      },
      {
        id: 'v2',
        name: 'Craft Brew Co',
        coordinates: { latitude: 51.5120, longitude: -0.1300 },
        icon: 'beer',
        isHighlighted: false
      }
    ];
  },

  getCurrentLocation: async () => {
    return {
      city: 'London, UK',
      region: {
        latitude: 51.5074,
        longitude: -0.1278,
        latitudeDelta: 0.05,
        longitudeDelta: 0.05,
      }
    };
  },
  getCities: async () => {
    return [
      { id: '1', name: 'London', country: 'UK', coordinates: { latitude: 51.5074, longitude: -0.1278 } },
      { id: '2', name: 'New York', country: 'USA', coordinates: { latitude: 40.7128, longitude: -74.0060 } },
      { id: '3', name: 'Tokyo', country: 'Japan', coordinates: { latitude: 35.6762, longitude: 139.6503 } },
      { id: '4', name: 'Paris', country: 'France', coordinates: { latitude: 48.8566, longitude: 2.3522 } },
      { id: '5', name: 'San Francisco', country: 'USA', coordinates: { latitude: 37.7749, longitude: -122.4194 } },
    ];
  },

  getVenuesByCity: async (cityId: string) => {
    // Mocking venues based on city selection
    const mockVenues: any = {
      '1': [
        { id: 'v1', name: 'Espresso Martini', venue: 'The Cocktail Bar, London', coordinates: { latitude: 51.5048, longitude: -0.1235 }, icon: 'glass-cocktail' },
        { id: 'v2', name: 'Matcha Latte', venue: 'Zen Coffee House, London', coordinates: { latitude: 51.5120, longitude: -0.1300 }, icon: 'coffee' },
      ],
      'default': [
        { id: 'd1', name: 'Classic Brown Sugar Milk Tea', venue: 'Boba Paradise', coordinates: { latitude: 51.5074, longitude: -0.1278 }, icon: 'cup' },
        { id: 'd2', name: 'Hazy IPA', venue: 'Craft Brew Co', coordinates: { latitude: 51.5090, longitude: -0.1250 }, icon: 'beer' },
      ]
    };
    return mockVenues[cityId] || mockVenues['default'];
  }
};