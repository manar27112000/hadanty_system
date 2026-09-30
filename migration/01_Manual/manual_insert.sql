USE Hadanty;
GO

-- =============================================
-- Manual Data Migration
-- Source: Old System
-- Target: Hadanty
-- =============================================

INSERT INTO Child
(
    child_id,
    first_name,
    last_name,
    national_id,
    date_of_birth,
    gender,
    status
)
VALUES
(
    1001,
    'Ahmed',
    'Ali',
    '301234567890',
    '2020-05-12',
    'Male',
    'Active'
),
(
    1002,
    'Mariam',
    'Hassan',
    '301234567891',
    '2019-11-03',
    'Female',
    'Active'
),
(
    1003,
    'Omar',
    'Adel',
    '301234567892',
    '2021-02-20',
    'Male',
    'Active'
);
GO

-- Verification
SELECT
    child_id,
    first_name,
    last_name,
    national_id,
    date_of_birth,
    gender,
    status
FROM Child
WHERE child_id IN (1001, 1002, 1003);
GO




