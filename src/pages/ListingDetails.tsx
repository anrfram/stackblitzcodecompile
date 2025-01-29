import React from 'react';
import { useParams } from 'react-router-dom';
import { supabase } from '../lib/supabase';

interface CarListing {
  id: string;
  title: string;
  description: string;
  price: number;
  mileage: number;
  year: number;
  condition: string;
  transmission: string;
  color: string;
  vin: string;
  images: string[];
  car_brands: {
    name: string;
  };
  car_models: {
    name: string;
  };
  profiles: {
    full_name: string;
    email: string;
  };
}

export default function ListingDetails() {
  const { id } = useParams<{ id: string }>();
  const [listing, setListing] = React.useState<CarListing | null>(null);
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState<string | null>(null);

  React.useEffect(() => {
    if (id) {
      fetchListing(id);
    }
  }, [id]);

  async function fetchListing(listingId: string) {
    try {
      const { data, error } = await supabase
        .from('car_listings')
        .select(`
          *,
          car_brands (name),
          car_models (name),
          profiles (full_name, email)
        `)
        .eq('id', listingId)
        .single();

      if (error) throw error;
      setListing(data);
    } catch (error) {
      setError(error instanceof Error ? error.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  }

  if (loading) return <div className="text-center">Loading...</div>;
  if (error) return <div className="text-red-600">{error}</div>;
  if (!listing) return <div className="text-center">Listing not found</div>;

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <div className="relative h-96">
          <img
            src={listing.images[0] || 'https://via.placeholder.com/800x600'}
            alt={listing.title}
            className="w-full h-full object-cover"
          />
        </div>
        <div className="p-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">{listing.title}</h1>
          <p className="text-xl text-blue-600 font-bold mb-4">
            ${listing.price.toLocaleString()}
          </p>
          
          <div className="grid grid-cols-2 gap-4 mb-6">
            <div>
              <h2 className="text-sm text-gray-500">Make & Model</h2>
              <p className="text-lg">{listing.car_brands.name} {listing.car_models.name}</p>
            </div>
            <div>
              <h2 className="text-sm text-gray-500">Year</h2>
              <p className="text-lg">{listing.year}</p>
            </div>
            <div>
              <h2 className="text-sm text-gray-500">Mileage</h2>
              <p className="text-lg">{listing.mileage.toLocaleString()} miles</p>
            </div>
            <div>
              <h2 className="text-sm text-gray-500">Condition</h2>
              <p className="text-lg capitalize">{listing.condition}</p>
            </div>
            <div>
              <h2 className="text-sm text-gray-500">Transmission</h2>
              <p className="text-lg capitalize">{listing.transmission}</p>
            </div>
            <div>
              <h2 className="text-sm text-gray-500">Color</h2>
              <p className="text-lg">{listing.color}</p>
            </div>
          </div>

          <div className="mb-6">
            <h2 className="text-xl font-semibold mb-2">Description</h2>
            <p className="text-gray-700 whitespace-pre-line">{listing.description}</p>
          </div>

          <div className="border-t pt-6">
            <h2 className="text-xl font-semibold mb-2">Contact Seller</h2>
            <p className="text-gray-700">{listing.profiles.full_name}</p>
            <a
              href={`mailto:${listing.profiles.email}`}
              className="inline-block bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 mt-2"
            >
              Send Email
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}