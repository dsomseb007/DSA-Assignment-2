
-- Create a table to store user information
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    job_title VARCHAR(255),
    position VARCHAR(255),
    role ENUM('HoD', 'Supervisor', 'Employee')
);

-- Create a table to store objectives
CREATE TABLE objectives (
    objective_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,
    description TEXT,
    weightage DECIMAL(5, 2),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create a table to store performance records (KPIs)
CREATE TABLE performance_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    objective_id INT,
    metric_name VARCHAR(255),
    value DECIMAL(10, 2),
    unit VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (objective_id) REFERENCES objectives(objective_id)
);

-- Create a table to store department information
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    ...

);
