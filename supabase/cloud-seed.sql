-- ============================================================
-- Nexus Academy — Cloud Seed Script
-- Insert-only: no DDL. Run once against the cloud database
-- (e.g. Supabase Dashboard SQL Editor).
--
-- IDs are database-generated; foreign keys are resolved
-- through a CTE RETURNING chain. The WHERE NOT EXISTS guard
-- on the course makes a repeat run a no-op: every later CTE
-- selects from the one before it, so if the course insert
-- returns no row, nothing else is inserted.
-- ============================================================

WITH course AS (
    INSERT INTO courses (title, description)
    SELECT 'Nexus Academy', 'The Nexus Trader Transformation System'
    WHERE NOT EXISTS (SELECT 1 FROM courses WHERE title = 'Nexus Academy')
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
