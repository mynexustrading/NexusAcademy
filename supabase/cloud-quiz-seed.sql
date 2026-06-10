-- ============================================================
-- Nexus Academy — Cloud Quiz Seed Script
-- Insert-only: no DDL. Run once against the cloud database
-- (e.g. Supabase Dashboard SQL Editor).
--
-- Requires the 'Introduction to Trading' module to exist
-- (created by cloud-seed.sql). IDs are database-generated;
-- foreign keys are resolved through a CTE RETURNING chain.
-- The WHERE NOT EXISTS guard on the quiz makes a repeat run
-- a no-op: every later CTE selects from the one before it,
-- so if the quiz insert returns no row, nothing is inserted.
-- ============================================================

WITH quiz AS (
    INSERT INTO quizzes (module_id, quiz_type, title, pass_score, is_required)
    SELECT id, 'module', 'Introduction to Trading — Module Quiz', 80, true
    FROM modules
    WHERE title = 'Introduction to Trading'
      AND NOT EXISTS (
          SELECT 1 FROM quizzes WHERE title = 'Introduction to Trading — Module Quiz'
      )
    RETURNING id
),
qs AS (
    INSERT INTO questions (quiz_id, question_text, question_type, order_index)
    SELECT quiz.id, q.question_text, 'multiple_choice', q.order_index
    FROM quiz,
        (VALUES
            ('What is trading?', 1),
            ('Which market participants typically move markets the most?', 2),
            ('What is the commonly recommended maximum risk per trade?', 3),
            ('What is a stop loss?', 4),
            ('Why is keeping a trading journal important?', 5)
        ) AS q(question_text, order_index)
    RETURNING id, order_index
)
INSERT INTO answers (question_id, answer_text, is_correct, order_index)
SELECT qs.id, a.answer_text, a.is_correct, a.order_index
FROM qs
JOIN (VALUES
    (1, 'Buying and selling financial instruments to profit from price changes', true,  1),
    (1, 'Gambling on random market movements',                                  false, 2),
    (1, 'Holding investments for decades without selling',                      false, 3),
    (1, 'Copying other people''s trades automatically',                         false, 4),
    (2, 'Retail traders',                                                       false, 1),
    (2, 'Institutional investors',                                              true,  2),
    (2, 'Social media influencers',                                             false, 3),
    (2, 'News reporters',                                                       false, 4),
    (3, '10-20% of the account',                                                false, 1),
    (3, '50% of the account',                                                   false, 2),
    (3, '1-2% of the account',                                                  true,  3),
    (3, 'There is no need to limit risk',                                       false, 4),
    (4, 'An order that closes a losing trade at a predefined price',            true,  1),
    (4, 'A guarantee that a trade cannot lose money',                           false, 2),
    (4, 'A fee charged by the broker',                                          false, 3),
    (4, 'A signal to enter a trade',                                            false, 4),
    (5, 'It impresses other traders',                                           false, 1),
    (5, 'It is required by brokers',                                            false, 2),
    (5, 'It guarantees profitable trades',                                      false, 3),
    (5, 'It builds evidence and improves decisions through reflection',         true,  4)
) AS a(q_order, answer_text, is_correct, order_index) ON a.q_order = qs.order_index;
