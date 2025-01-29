import React from 'react';
import { Link } from 'react-router-dom';
import { Filter } from 'lucide-react';
import { supabase } from '../lib/supabase';

interface CarListing {
  id: string;
  title: string;
  price: number;
  mileage: number;
  year: number;
  transmission: string;
  condition: string;
  images: string[];
  car_brands: {
    name: string;
  };
  car_models: {
    name: string;
  };
}

interface CarBrand {
  id: string;
  name: string;
}

interface CarModel {
  id: string;
  name: string;
}

interface Filters {
  brand_id?: string;
  model_id?: string;
  minPrice?: number;
  maxPrice?: number;
  minYear?: number;
  maxYear?: number;
  minMileage?: number;
  maxMileage?: number;
  transmission?: string;
  condition?: string;
}

export default function Home() {
  const [listings, setListings] = React.useState<CarListing[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [brands, setBrands] = React.useState<CarBrand[]>([]);
  const [models, setModels] = React.useState<CarModel[]>([]);
  const [filters, setFilters] = React.useState<Filters>({});
  const [showFilters, setShowFilters] = React.useState(false);

  React.useEffect(() => {
    fetchBrands();
    fetchListings();
  }, []);

  React.useEffect(() => {
    if (filters.brand_id) {
      fetchModels(filters.brand_id);
    } else {
      setModels([]);
      setFilters(prev => ({ ...prev, model_id: undefined }));
    }
  }, [filters.brand_id]);

  async function fetchBrands() {
    try {
      const { data } = await supabase
        .from('car_brands')
        .select('*')
        .order('name');
      setBrands(data || []);
    } catch (error) {
      console.error('Error fetching brands:', error);
    }
  }

  async function fetchModels(brandId: string) {
    try {
      const { data } = await supabase
        .from('car_models')
        .select('*')
        .eq('brand_id', brandId)
        .order('name');
      setModels(data || []);
    } catch (error) {
      console.error('Error fetching models:', error);
    }
  }

  async function fetchListings() {
    try {
      let query = supabase
        .from('car_listings')
        .select(`
          *,
          car_brands (name),
          car_models (name)
        `)
        .order('created_at', { ascending: false });

      if (filters.brand_id) {
        query = query.eq('brand_id', filters.brand_id);
      }
      if (filters.model_id) {
        query = query.eq('model_id', filters.model_id);
      }
      if (filters.minPrice) {
        query = query.gte('price', filters.minPrice);
      }
      if (filters.maxPrice) {
        query = query.lte('price', filters.maxPrice);
      }
      if (filters.minYear) {
        query = query.gte('year', filters.minYear);
      }
      if (filters.maxYear) {
        query = query.lte('year', filters.maxYear);
      }
      if (filters.minMileage) {
        query = query.gte('mileage', filters.minMileage);
      }
      if (filters.maxMileage) {
        query = query.lte('mileage', filters.maxMileage);
      }
      if (filters.transmission) {
        query = query.eq('transmission', filters.transmission);
      }
      if (filters.condition) {
        query = query.eq('condition', filters.condition);
      }

      const { data, error } = await query;

      if (error) throw error;
      setListings(data || []);
    } catch (error) {
      console.error('Error fetching listings:', error);
    } finally {
      setLoading(false);
    }
  }

  const handleFilterChange = (name: string, value: string | number | undefined) => {
    setFilters(prev => ({ ...prev, [name]: value }));
  };

  const applyFilters = () => {
    setLoading(true);
    fetchListings();
    setShowFilters(false);
  };

  const resetFilters = () => {
    setFilters({});
    setLoading(true);
    fetchListings();
    setShowFilters(false);
  };

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          Drive German Excellence – Affordable Luxury, Pre-Owned
        </h1>
        <div className="flex gap-4 mb-4">
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
          >
            <Filter className="h-5 w-5" />
            {showFilters ? 'Hide Filters' : 'Show Filters'}
          </button>
        </div>

        {showFilters && (
          <div className="bg-white p-6 rounded-lg shadow-md mb-6">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Brand</label>
                <select
                  value={filters.brand_id || ''}
                  onChange={(e) => handleFilterChange('brand_id', e.target.value || undefined)}
                  className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                >
                  <option value="">All Brands</option>
                  {brands.map((brand) => (
                    <option key={brand.id} value={brand.id}>
                      {brand.name}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Model</label>
                <select
                  value={filters.model_id || ''}
                  onChange={(e) => handleFilterChange('model_id', e.target.value || undefined)}
                  disabled={!filters.brand_id}
                  className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                >
                  <option value="">All Models</option>
                  {models.map((model) => (
                    <option key={model.id} value={model.id}>
                      {model.name}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Transmission</label>
                <select
                  value={filters.transmission || ''}
                  onChange={(e) => handleFilterChange('transmission', e.target.value || undefined)}
                  className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                >
                  <option value="">Any</option>
                  <option value="automatic">Automatic</option>
                  <option value="manual">Manual</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Condition</label>
                <select
                  value={filters.condition || ''}
                  onChange={(e) => handleFilterChange('condition', e.target.value || undefined)}
                  className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                >
                  <option value="">Any</option>
                  <option value="used">Used</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Price Range</label>
                <div className="grid grid-cols-2 gap-2">
                  <input
                    type="number"
                    placeholder="Min"
                    value={filters.minPrice || ''}
                    onChange={(e) => handleFilterChange('minPrice', e.target.value ? Number(e.target.value) : undefined)}
                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                  <input
                    type="number"
                    placeholder="Max"
                    value={filters.maxPrice || ''}
                    onChange={(e) => handleFilterChange('maxPrice', e.target.value ? Number(e.target.value) : undefined)}
                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Year Range</label>
                <div className="grid grid-cols-2 gap-2">
                  <input
                    type="number"
                    placeholder="Min"
                    value={filters.minYear || ''}
                    onChange={(e) => handleFilterChange('minYear', e.target.value ? Number(e.target.value) : undefined)}
                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                  <input
                    type="number"
                    placeholder="Max"
                    value={filters.maxYear || ''}
                    onChange={(e) => handleFilterChange('maxYear', e.target.value ? Number(e.target.value) : undefined)}
                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Mileage Range</label>
                <div className="grid grid-cols-2 gap-2">
                  <input
                    type="number"
                    placeholder="Min"
                    value={filters.minMileage || ''}
                    onChange={(e) => handleFilterChange('minMileage', e.target.value ? Number(e.target.value) : undefined)}
                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                  <input
                    type="number"
                    placeholder="Max"
                    value={filters.maxMileage || ''}
                    onChange={(e) => handleFilterChange('maxMileage', e.target.value ? Number(e.target.value) : undefined)}
                    className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
              </div>
            </div>

            <div className="flex justify-between mt-6">
              <button
                onClick={resetFilters}
                className="px-4 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200"
              >
                Reset Filters
              </button>
              <button
                onClick={applyFilters}
                className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
              >
                Apply Filters
              </button>
            </div>
          </div>
        )}
      </div>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {listings.map((listing) => (
            <div
              key={listing.id}
              className="bg-white shadow-md rounded-md p-4 flex flex-col justify-between"
            >
              <Link to={`/car/${listing.id}`}>
                <img
                  src={listing.images[0]}
                  alt={listing.title}
                  className="w-full h-48 object-cover rounded-md"
                />
              </Link>
              <div className="mt-4">
                <h2 className="text-lg font-medium text-gray-900">{listing.title}</h2>
                <p className="text-sm text-gray-500">
                  {listing.car_brands.name} {listing.car_models.name} - {listing.year}
                </p>
                <p className="text-lg font-semibold text-gray-800">${listing.price.toLocaleString()}</p>
                <p className="text-sm text-gray-500">
                  {listing.mileage.toLocaleString()} km - {listing.transmission} - {listing.condition}
                </p>
              </div>
              <Link
                to={`/car/${listing.id}`}
                className="mt-4 px-4 py-2 bg-blue-600 text-white text-center rounded-md hover:bg-blue-700"
              >
                View Details
              </Link>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
