/*
  # Initial Schema for German Auto Marketplace

  1. New Tables
    - `profiles`
      - Extends Supabase auth with additional user info
      - Stores user profile data like name and contact details
    
    - `car_listings`
      - Stores vehicle listings
      - Contains detailed car information and pricing
      - Links to user profiles
    
    - `car_brands`
      - Reference table for German car manufacturers
      - Ensures data consistency for brands
    
    - `car_models`
      - Reference table for car models
      - Links to brands for proper categorization

  2. Security
    - RLS enabled on all tables
    - Public read access for listings and reference data
    - Protected write access for user data and listings
*/

-- Create enum for car condition
CREATE TYPE car_condition AS ENUM ('new', 'used', 'certified');

-- Create enum for transmission type
CREATE TYPE transmission_type AS ENUM ('automatic', 'manual');

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  email text NOT NULL,
  full_name text,
  phone text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create German car brands table
CREATE TABLE IF NOT EXISTS car_brands (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  logo_url text,
  created_at timestamptz DEFAULT now()
);

-- Create car models table
CREATE TABLE IF NOT EXISTS car_models (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id uuid REFERENCES car_brands(id) NOT NULL,
  name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  UNIQUE(brand_id, name)
);

-- Create car listings table
CREATE TABLE IF NOT EXISTS car_listings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  seller_id uuid REFERENCES profiles(id) NOT NULL,
  brand_id uuid REFERENCES car_brands(id) NOT NULL,
  model_id uuid REFERENCES car_models(id) NOT NULL,
  title text NOT NULL,
  description text,
  year integer NOT NULL,
  price decimal(12,2) NOT NULL,
  mileage integer NOT NULL,
  condition car_condition NOT NULL,
  transmission transmission_type NOT NULL,
  color text,
  vin text,
  images text[] DEFAULT ARRAY[]::text[],
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE car_brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE car_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE car_listings ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Car brands policies
CREATE POLICY "Anyone can view car brands"
  ON car_brands FOR SELECT
  USING (true);

-- Car models policies
CREATE POLICY "Anyone can view car models"
  ON car_models FOR SELECT
  USING (true);

-- Car listings policies
CREATE POLICY "Anyone can view listings"
  ON car_listings FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create listings"
  ON car_listings FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = seller_id); 

CREATE POLICY "Users can update own listings"
  ON car_listings FOR UPDATE
  USING (auth.uid() = seller_id);

CREATE POLICY "Users can delete own listings"
  ON car_listings FOR DELETE
  USING (auth.uid() = seller_id);

-- Insert German car brands
INSERT INTO car_brands (name, logo_url) VALUES
  ('Mercedes-Benz', 'https://example.com/mercedes.png'),
  ('BMW', 'https://example.com/bmw.png'),
  ('Audi', 'https://example.com/audi.png'),
  ('Porsche', 'https://example.com/porsche.png'),
  ('Volkswagen', 'https://example.com/vw.png')
ON CONFLICT (name) DO NOTHING;



-- Insert German car models with reference to brands
INSERT INTO car_models (brand_id, name) VALUES

  ((SELECT id FROM car_brands WHERE name = 'BMW'), '1 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '2 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '3 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '5 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '6 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '7 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '8 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M3'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M4'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M5'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M6'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M8'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X1'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X2'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X3'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X4'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X5'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X6'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X7'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'Z3'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'Z4'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'Z8'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '128i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '135i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '135is'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '1 Series M'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '228i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '228i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '228i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '228i xDrive Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '230i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M235i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M235i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M235i xDrive Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M240i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M240i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '318i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '318iS'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '318ti'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '320i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '320i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '323ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '323i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '323is'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325e'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325es'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325is'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325iX'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '325xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328Ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328d'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328d xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328iS'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '328xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330e'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330e xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '330xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '335d'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '335i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '335i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '335i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '335is'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '335xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '340i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '340i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '340i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ActiveHybrid 3'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M340i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M340i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '428i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '428i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '428i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '428i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '430i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '430i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '430i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '430i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '435i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '435i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '435i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '435i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '440i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '440i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '440i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '440i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M440i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M440i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M440i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M440i xDrive Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '524td'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '525i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '525xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '528e'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '528i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '528i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '528xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '530e'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '530e xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '530i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '530i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '530xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '533i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535d'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535d xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535i Gran Turismo'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '535xi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '540d xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '540i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '540i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '545i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '550e xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '550i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '550i Gran Turismo'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '550i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '550i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ActiveHybrid 5'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M550i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '633CSi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '635CSi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '640i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '640i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '640i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '640i Gran Turismo xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '640i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '645ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '650i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '650i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '650i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '650i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ALPINA B6 xDrive Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'L6'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '733i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '735i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '735iL'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740e xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740iL'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740Ld xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740Li'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '740Li xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '745e xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '745i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '745Li'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '750e xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '750i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '750i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '750iL'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '750Li'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '750Li xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '760i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '760i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '760Li'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ActiveHybrid 7'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ALPINA B7 xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ALPINA B7 xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'L7'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M760i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '840ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '840i Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '840i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '840i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '850ci'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '850CSi'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '850i'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ALPINA B8 xDrive Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M850i Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M850i xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ActiveHybrid X6'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'ALPINA XB7'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'i3'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'i4'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'i5'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'i7'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'i8'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'iX'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M Roadster'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M3 xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M4 xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M6 Gran Coupe'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'M8 Gran Coupe xDrive'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X3 M'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X4 M'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X5 M'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X6 M'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'XM'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'Other'),

  ((SELECT id FROM car_brands WHERE name = 'Mercedes-Benz'), 'C-Class'),
  ((SELECT id FROM car_brands WHERE name = 'Mercedes-Benz'), 'E-Class'),
  ((SELECT id FROM car_brands WHERE name = 'Mercedes-Benz'), 'S-Class'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '3 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '1 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), '5 Series'),
  ((SELECT id FROM car_brands WHERE name = 'BMW'), 'X5'),
  ((SELECT id FROM car_brands WHERE name = 'Audi'), 'A3'),
  ((SELECT id FROM car_brands WHERE name = 'Audi'), 'A4'),
  ((SELECT id FROM car_brands WHERE name = 'Audi'), 'Q5'),
  ((SELECT id FROM car_brands WHERE name = 'Porsche'), '911'),
  ((SELECT id FROM car_brands WHERE name = 'Porsche'), 'Cayenne'),
  ((SELECT id FROM car_brands WHERE name = 'Porsche'), 'Macan'),
  ((SELECT id FROM car_brands WHERE name = 'Volkswagen'), 'Golf'),
  ((SELECT id FROM car_brands WHERE name = 'Volkswagen'), 'Passat'),
  ((SELECT id FROM car_brands WHERE name = 'Volkswagen'), 'Tiguan')
ON CONFLICT (name, brand_id) DO NOTHING;




-- Create a policy to allow authenticated users to insert their profiles
CREATE POLICY "Allow authenticated users to insert profiles"
  ON public.profiles
  FOR INSERT
  USING (auth.uid() IS NOT NULL);

-- Enable RLS for the profiles table (if not enabled already)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Create the function to insert a new profile when a new user is created in the auth.users table
CREATE OR REPLACE FUNCTION insert_user_profile()
RETURNS TRIGGER AS $$
BEGIN
  -- Insert the user's profile into the profiles table in the public schema
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.email); -- Default full_name as email (can change as needed)

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Create the trigger to call the function when a new user is inserted into the auth.users table
CREATE TRIGGER insert_profile_after_user_creation
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION insert_user_profile();
