USE Hadanty;
GO

-- =============================================
-- 1. Bus
-- Branch 1 : N Bus
-- =============================================

CREATE TABLE Bus (
    bus_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    bus_number VARCHAR(50) NOT NULL,
    license_plate VARCHAR(50),
    capacity INT,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Bus_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 2. Driver
-- Branch 1 : N Driver
-- =============================================

CREATE TABLE Driver (
    driver_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    license_number VARCHAR(50),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Driver_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 3. BusSupervisor
-- Branch 1 : N BusSupervisor
-- =============================================

CREATE TABLE BusSupervisor (
    supervisor_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_BusSupervisor_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 4. TransportRoute
-- Branch 1 : N TransportRoute
-- =============================================

CREATE TABLE TransportRoute (
    route_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_TransportRoute_Branch
        FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO


-- =============================================
-- 5. TransportStop
-- TransportRoute 1 : N TransportStop
-- =============================================

CREATE TABLE TransportStop (
    stop_id INT IDENTITY(1,1) PRIMARY KEY,
    route_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    sequence_no INT NOT NULL,
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),

    CONSTRAINT FK_TransportStop_Route
        FOREIGN KEY (route_id)
        REFERENCES TransportRoute(route_id),

    CONSTRAINT UQ_TransportStop_Route_Sequence
        UNIQUE (route_id, sequence_no)
);
GO


-- =============================================
-- 6. TransportTrip
-- Route 1 : N Trip
-- Bus 1 : N Trip
-- Driver 1 : N Trip
-- BusSupervisor 1 : N Trip
-- =============================================

CREATE TABLE TransportTrip (
    trip_id INT IDENTITY(1,1) PRIMARY KEY,
    route_id INT NOT NULL,
    bus_id INT NOT NULL,
    driver_id INT NOT NULL,
    supervisor_id INT NOT NULL,
    trip_date DATE NOT NULL,
    trip_type VARCHAR(50) NOT NULL,
    start_time DATETIME2,
    arrival_time DATETIME2,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',

    CONSTRAINT FK_TransportTrip_Route
        FOREIGN KEY (route_id)
        REFERENCES TransportRoute(route_id),

    CONSTRAINT FK_TransportTrip_Bus
        FOREIGN KEY (bus_id)
        REFERENCES Bus(bus_id),

    CONSTRAINT FK_TransportTrip_Driver
        FOREIGN KEY (driver_id)
        REFERENCES Driver(driver_id),

    CONSTRAINT FK_TransportTrip_Supervisor
        FOREIGN KEY (supervisor_id)
        REFERENCES BusSupervisor(supervisor_id)
);
GO


-- =============================================
-- 7. TripChild
-- TransportTrip M : N Child
-- =============================================

CREATE TABLE TripChild (
    trip_child_id INT IDENTITY(1,1) PRIMARY KEY,
    trip_id INT NOT NULL,
    child_id INT NOT NULL,
    boarding_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    boarding_time DATETIME2,
    arrival_time DATETIME2,
    pickup_time DATETIME2,

    CONSTRAINT FK_TripChild_Trip
        FOREIGN KEY (trip_id)
        REFERENCES TransportTrip(trip_id),

    CONSTRAINT FK_TripChild_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT UQ_TripChild_Trip_Child
        UNIQUE (trip_id, child_id)
);
GO


-- =============================================
-- 8. ChildTransportStop
-- Child 1 : N ChildTransportStop
-- TransportStop 1 : N ChildTransportStop
-- =============================================

CREATE TABLE ChildTransportStop (
    child_transport_stop_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT NOT NULL,
    stop_id INT NOT NULL,
    stop_type VARCHAR(50) NOT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_ChildTransportStop_Child
        FOREIGN KEY (child_id)
        REFERENCES Child(child_id),

    CONSTRAINT FK_ChildTransportStop_Stop
        FOREIGN KEY (stop_id)
        REFERENCES TransportStop(stop_id)
);
GO