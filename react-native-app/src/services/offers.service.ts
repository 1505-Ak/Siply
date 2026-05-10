export const offersService = {
  getOverview: async () => {
    return {
      userPoints: 405,
      discountsCount: 4,
      loyaltyProgramsCount: 6
    };
  },

  getDiscountCategories: async () => {
    return [
      // Changed IDs to match filenames: favorites.tsx, near-you.tsx, etc.
      { id: 'favorites', name: 'Your Favorites', count: 0, icon: 'heart', color: '#6C244C' },
      { id: 'near-you', name: 'Near You', count: 6, icon: 'navigate', color: '#83935A' }, // Changed 'navigation' to 'navigate'
      { id: 'student-deals', name: 'Student Deals', count: 4, icon: 'school', color: '#BF875D' },
      { id: 'happy-hour', name: 'Happy Hour', count: 3, icon: 'sunny', color: '#D0FF14' },
    ];
  },

  getLoyaltyPrograms: async () => {
    return [
      { id: 'l1', name: 'Points Multiplier', desc: 'Earn bonus points', count: 2, icon: 'close-thick', color: '#83935A' },
      { id: 'l2', name: 'Subscriptions', desc: 'Monthly perks & savings', count: 2, icon: 'crown', color: '#BF875D' },
      { id: 'l3', name: 'Visit Counter Card', desc: 'Collect stamps for rewards', count: 3, icon: 'dots-grid', color: '#6C244C' },
      { id: 'l4', name: 'Exclusive Member Offers', desc: 'Special deals for members', count: 1, icon: 'star', color: '#4E545B' },      
    ];
  },

  // Used by My Favorites screen
  getFavorites: async () => {
    return []; // Return empty array to show "No favorites yet" screen
  },

  // Used by Near You screen
  getNearYouVenues: async () => {
    return [
      {
        id: 'v1',
        name: 'Starbucks',
        address: '123 Main St',
        distance: '0.5 km away',
        image: 'coffee',
        deals: [
          { label: 'Student Discount', value: '10% off' },
          { label: 'Free Birthday Drink', value: null }
        ]
      },
      {
        id: 'v2',
        name: 'Costa Coffee',
        address: '456 High St',
        distance: '0.5 km away',
        image: 'coffee',
        deals: [{ label: 'Happy Hour Special', value: '30% off' }]
      }
    ];
  },

  getStudentDeals: async () => {
    return [
      {
        id: 's1',
        name: 'Starbucks',
        address: '123 Main St',
        image: 'coffee',
        deals: [
          { label: 'Student Discount', value: '10% off' },
          { label: 'Free Birthday Drink', value: null }
        ]
      },
      {
        id: 's2',
        name: 'Costa Coffee',
        address: '456 High St',
        image: 'coffee',
        deals: [{ label: 'Happy Hour Special', value: '30% off' }]
      },
      {
        id: 's3',
        name: 'Local Brew',
        address: '789 Oak Ave',
        image: 'coffee',
        deals: [{ label: 'Student Special', value: '15% off' }]
      },
      {
        id: 's4',
        name: 'Dunkin\'',
        address: '111 Bakery Rd',
        image: 'donut',
        deals: [{ label: 'Student Saver', value: '10% off' }]
      }
    ];
  },

  getHappyHourVenues: async () => {
    return [
      {
        id: 'h1',
        name: 'Costa Coffee',
        time: '15:00 - 17:00',
        days: 'Monday, Tuesday, Wednesday',
        deal: '30% off all iced drinks',
        image: 'coffee',
      },
      {
        id: 'h2',
        name: 'Local Brew',
        time: '17:00 - 19:00',
        days: 'Thursday, Friday',
        deal: '50% off all drinks',
        image: 'coffee',
      },
      {
        id: 'h3',
        name: 'Dunkin\'',
        time: '14:00 - 16:00',
        days: 'Monday, Wednesday, Friday',
        deal: 'Any size iced coffee for $2',
        image: 'donut',
      }
    ];
  },
  getVisitCards: async () => {
    return [
      { id: 'vc1', name: 'Starbucks', address: '123 Main St', currentVisits: 0, goalVisits: 10, icon: 'coffee' },
      { id: 'vc2', name: 'Costa Coffee', address: '456 High St', currentVisits: 0, goalVisits: 8, icon: 'coffee' },
      { id: 'vc3', name: 'Local Brew', address: '789 Oak Ave', currentVisits: 0, goalVisits: 5, icon: 'coffee' },
    ];
  }
};