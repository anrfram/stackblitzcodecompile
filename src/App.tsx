import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Car, User } from 'lucide-react';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Login from './pages/Login';
import Register from './pages/Register';
import ListingCreate from './pages/ListingCreate';
import ListingDetails from './pages/ListingDetails';
import Profile from './pages/Profile';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50">
        <Navbar />
        <main className="container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route path="/listings/create" element={<ListingCreate />} />
            <Route path="/listings/:id" element={<ListingDetails />} />
            <Route path="/profile" element={<Profile />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;