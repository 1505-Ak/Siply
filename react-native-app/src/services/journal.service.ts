export const journalService = {
  getStats: async () => {
    return {
      totalDrinks: 4,
      places: 4,
      avgRating: 4.6
    };
  },

  getEntries: async () => {
    return [
      {
        id: '1',
        name: 'Hazy IPA',
        rating: 4.8,
        venue: 'Craft Brew Co',
        location: 'Portland',
        date: '12 February 2026',
        category: 'Beer',
        isFavorite: false,
        icon: 'beer'
      },
      {
        id: '2',
        name: 'Matcha Latte',
        rating: 5.0,
        venue: 'Zen Coffee House',
        location: 'Tokyo',
        date: '12 February 2026',
        category: 'Coffee',
        isFavorite: true,
        icon: 'coffee'
      },
      {
        id: '3',
        name: 'Classic Brown Sugar Milk Tea',
        rating: 4.0,
        venue: 'Boba Paradise',
        location: 'San Francisco',
        date: '12 February 2026',
        category: 'Bubble Tea',
        isFavorite: false,
        icon: 'cup'
      },
      {
        id: '4',
        name: 'Espresso Martini',
        rating: 4.5,
        venue: 'The Cocktail Bar',
        location: 'London',
        date: '12 February 2026',
        category: 'Cocktail',
        isFavorite: false,
        icon: 'glass-cocktail'
      }
    ];
  },
  sortEntries: (data: any[], criterion: string) => {
    const sortedData = [...data];
    if (criterion === 'Date (Newest)') return sortedData.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
    if (criterion === 'Date (Oldest)') return sortedData.sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime());
    if (criterion === 'Rating (Highest)') return sortedData.sort((a, b) => b.rating - a.rating);
    if (criterion === 'Rating (Lowest)') return sortedData.sort((a, b) => a.rating - b.rating);
    if (criterion === 'Name (A-Z)') return sortedData.sort((a, b) => a.name.localeCompare(b.name));
    return sortedData;
  }
};