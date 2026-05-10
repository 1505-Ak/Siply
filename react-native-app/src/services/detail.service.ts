import { drinkService } from './drink.service';
import { journalService } from './journal.service';

export const detailService = {
  getDrinkById: async (id: string) => {
    // 1. Combine all our dummy data into one searchable list
    const allEntries = await journalService.getEntries();
    const feedPosts = await drinkService.getFeed();
    
    // Extract drinks from feed posts
    const feedDrinks = feedPosts.map(p => ({
      id: p.id, // using post id as drink id for mock
      name: p.drinkName,
      category: p.category,
      rating: p.rating,
      locationName: p.location,
      price: p.price.replace('$', ''),
      icon: p.category === 'Coffee' ? 'coffee' : 'glass-cocktail',
      date: p.time,
      notes: "This is a trending drink from the community feed!",
      tags: ['trending', p.category.toLowerCase()],
      likes: p.likes,
      shares: 5
    }));

    // 2. Find the drink that matches the ID
    const found = [...allEntries, ...feedDrinks].find(d => d.id === id);

    // 3. Return the found drink (or a default if not found)
    return found || allEntries[0]; 
  }
};