CREATE TYPE GOALCATEGORY AS ENUM('health', 'career', 'personal');
CREATE TYPE MEALTIME AS ENUM('breakfast', 'lunch', 'dinner', 'snack');
CREATE TYPE EVENTTYPE AS ENUM('workout', 'meal', 'study', 'goal_check', 'routine', 'misc');

CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(512),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE goals (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    category GOALCATEGORY NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    progress FLOAT,
    target_value FLOAT,
    current_value FLOAT
);

CREATE TABLE workouts (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    workout_name VARCHAR(50) NOT NULL,
    date_scheduled DATE NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE workout_exercises (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    workout_id INT REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_name VARCHAR(50) NOT NULL,
    sets INT NOT NULL,
    reps INT NOT NULL,
    resistance FLOAT NOT NULL
);

CREATE TABLE meals (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    meal_name VARCHAR(255) NOT NULL,
    calories FLOAT NOT NULL,
    protein FLOAT NOT NULL,
    carbs FLOAT NOT NULL,
    fats FLOAT NOT NULL,
    meal_time MEALTIME NOT NULL,
    recipe JSONB
);

CREATE TABLE meal_plan (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE schedules (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    event_name VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    is_recurring BOOLEAN DEFAULT FALSE,
    event_type EVENTTYPES NOT NULL
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_goals_category ON goals(category);
CREATE INDEX idx_workouts_user_id ON workouts(user_id);
CREATE INDEX idx_meals_user_id ON meals(user_id);
CREATE INDEX idx_meals_meal_time ON meals(meal_time);