-- ============================================================
-- Nexus Academy — Development Seed Data
-- Local development only. IDs are database-generated;
-- foreign keys are resolved through CTE RETURNING chains.
-- ============================================================

WITH course AS (
    INSERT INTO courses (title, description)
    VALUES ('Nexus Academy', 'The Nexus Trader Transformation System')
    RETURNING id
),
stage1 AS (
    INSERT INTO stages (course_id, title, order_index, is_hidden, is_mvp_active)
    SELECT id, 'Trader Foundations', 1, false, true
    FROM course
    RETURNING id
),
module1 AS (
    INSERT INTO modules (stage_id, title, order_index, description)
    SELECT id, 'Introduction to Trading', 1, 'Understand what trading is and how markets work'
    FROM stage1
    RETURNING id
),
module2 AS (
    INSERT INTO modules (stage_id, title, order_index, description)
    SELECT id, 'Trading Psychology', 2, 'Build the mental foundation of a disciplined trader'
    FROM stage1
    RETURNING id
),
module1_lessons AS (
    INSERT INTO lessons (module_id, title, order_index)
    SELECT id, lesson.title, lesson.order_index
    FROM module1,
        (VALUES
            ('What Is Trading', 1),
            ('Market Participants', 2),
            ('Risk Management Basics', 3)
        ) AS lesson(title, order_index)
    RETURNING id
)
INSERT INTO lessons (module_id, title, order_index)
SELECT id, lesson.title, lesson.order_index
FROM module2,
    (VALUES
        ('Discipline and Consistency', 1),
        ('Emotional Control', 2)
    ) AS lesson(title, order_index);
