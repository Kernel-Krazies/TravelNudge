-- ============================================
-- TRAVELNUDGE DATABASE SCHEMA
-- ============================================

-- 1. PROFILES
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    email TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 2. TRIPS
CREATE TABLE IF NOT EXISTS trips (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT,
    start_date DATE,
    end_date DATE,
    budget NUMERIC(10,2),
    status TEXT DEFAULT 'planning'
        CHECK (status IN ('planning', 'confirmed', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 3. TRIP PREFERENCES
CREATE TABLE IF NOT EXISTS trip_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID REFERENCES trips(id) ON DELETE CASCADE,
    vibe TEXT,
    interests TEXT,
    travel_style TEXT,
    food_preference TEXT,
    preferred_transport TEXT,
    max_daily_budget NUMERIC(10,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 4. DESTINATIONS
CREATE TABLE IF NOT EXISTS destinations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    city TEXT,
    country TEXT,
    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),
    description TEXT,
    recommended BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 5. ITINERARIES
CREATE TABLE IF NOT EXISTS itineraries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    destination_id UUID REFERENCES destinations(id) ON DELETE SET NULL,
    day_number INTEGER,
    date DATE,
    title TEXT,
    summary TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 6. ACTIVITIES
CREATE TABLE IF NOT EXISTS activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    itinerary_id UUID NOT NULL REFERENCES itineraries(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    activity_type TEXT,
    start_time TIME,
    end_time TIME,
    estimated_cost NUMERIC(10,2),
    duration_minutes INTEGER,
    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 7. WEATHER DATA
CREATE TABLE IF NOT EXISTS weather_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    destination_id UUID REFERENCES destinations(id) ON DELETE SET NULL,
    date DATE NOT NULL,
    temperature NUMERIC(5,2),
    feels_like NUMERIC(5,2),
    humidity INTEGER,
    wind_speed NUMERIC(6,2),
    weather_condition TEXT,
    precipitation_probability INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 8. AGENT RESULTS
CREATE TABLE IF NOT EXISTS agent_results (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    agent_name TEXT NOT NULL,
    input_data JSONB,
    output_data JSONB,
    reasoning_summary TEXT,
    confidence_score NUMERIC(5,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 9. TRAVEL SCORES
CREATE TABLE IF NOT EXISTS travel_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    vibe_score NUMERIC(5,2),
    budget_score NUMERIC(5,2),
    time_score NUMERIC(5,2),
    weather_score NUMERIC(5,2),
    preference_score NUMERIC(5,2),
    overall_score NUMERIC(5,2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 10. TRANSPORT OPTIONS
CREATE TABLE IF NOT EXISTS transport_options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
    transport_mode TEXT NOT NULL,
    provider TEXT,
    source_location TEXT NOT NULL,
    destination_location TEXT NOT NULL,
    estimated_cost NUMERIC(10,2),
    travel_time_minutes INTEGER,
    distance_km NUMERIC(10,2),
    departure_time TIMESTAMPTZ,
    arrival_time TIMESTAMPTZ,
    is_recommended BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);