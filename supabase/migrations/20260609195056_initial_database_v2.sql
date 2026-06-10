-- ============================================================
-- Nexus Academy — Database Architecture v2
-- Initial Migration
-- ============================================================

-- Group 2 — Identity & Capability (no deps; referenced by users, stages)

CREATE TABLE identities (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            TEXT        NOT NULL,
    order_index     INTEGER     NOT NULL,
    description     TEXT,
    is_mvp_active   BOOLEAN     NOT NULL DEFAULT true
);

CREATE TABLE capabilities (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code        TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    description TEXT
);

-- Group 3 — Curriculum (courses before stages)

CREATE TABLE courses (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title       TEXT        NOT NULL,
    description TEXT,
    status      TEXT        NOT NULL DEFAULT 'active',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Group 8 — Certification types (referenced by progression_rules and certificates)

CREATE TABLE certificate_types (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name          TEXT    NOT NULL,
    identity_id   UUID    REFERENCES identities(id),
    description   TEXT,
    order_index   INTEGER NOT NULL DEFAULT 0,
    is_mvp_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE stages (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id               UUID        NOT NULL REFERENCES courses(id),
    title                   TEXT        NOT NULL,
    order_index             INTEGER     NOT NULL,
    target_identity_from_id UUID        REFERENCES identities(id),
    target_identity_to_id   UUID        REFERENCES identities(id),
    is_hidden               BOOLEAN     NOT NULL DEFAULT false,
    is_mvp_active           BOOLEAN     NOT NULL DEFAULT true,
    unlock_type             TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Group 1 — User & Role

CREATE TABLE users (
    id                              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                            TEXT        NOT NULL,
    email                           TEXT        NOT NULL UNIQUE,
    password_hash                   TEXT        NOT NULL,
    role                            TEXT        NOT NULL CHECK (role IN ('student', 'mentor', 'admin', 'super_admin')),
    current_identity_id             UUID        REFERENCES identities(id),
    current_stage_id                UUID        REFERENCES stages(id),
    onboarding_completed            BOOLEAN     NOT NULL DEFAULT false,
    reality_calibration_accepted_at TIMESTAMPTZ,
    declared_max_risk_percent       NUMERIC(5, 2),
    created_at                      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_profiles (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID        NOT NULL REFERENCES users(id),
    experience_level  TEXT,
    primary_market    TEXT,
    current_challenge TEXT,
    main_goal         TEXT,
    country           TEXT,
    timezone          TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Group 2 — Identity & Capability (continued)

CREATE TABLE stage_capabilities (
    id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_id      UUID         NOT NULL REFERENCES stages(id),
    capability_id UUID         NOT NULL REFERENCES capabilities(id),
    weight        NUMERIC(5,2) NOT NULL DEFAULT 1.0
);

-- Group 3 — Curriculum (continued)

CREATE TABLE modules (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_id    UUID        NOT NULL REFERENCES stages(id),
    title       TEXT        NOT NULL,
    order_index INTEGER     NOT NULL,
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE lessons (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id   UUID        NOT NULL REFERENCES modules(id),
    title       TEXT        NOT NULL,
    order_index INTEGER     NOT NULL,
    video_url   TEXT,
    pdf_url     TEXT,
    notes       TEXT,
    lesson_type TEXT,
    is_required BOOLEAN     NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE lesson_completions (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID        NOT NULL REFERENCES users(id),
    lesson_id    UUID        NOT NULL REFERENCES lessons(id),
    completed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, lesson_id)
);

-- Group 4 — Assessment

CREATE TABLE quizzes (
    id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_id    UUID         REFERENCES stages(id),
    module_id   UUID         REFERENCES modules(id),
    lesson_id   UUID         REFERENCES lessons(id),
    quiz_type   TEXT         NOT NULL CHECK (quiz_type IN ('lesson', 'module', 'stage')),
    title       TEXT         NOT NULL,
    pass_score  NUMERIC(5,2) NOT NULL DEFAULT 80,
    is_required BOOLEAN      NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE questions (
    id            UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id       UUID    NOT NULL REFERENCES quizzes(id),
    question_text TEXT    NOT NULL,
    question_type TEXT    NOT NULL,
    order_index   INTEGER NOT NULL
);

CREATE TABLE answers (
    id          UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID    NOT NULL REFERENCES questions(id),
    answer_text TEXT    NOT NULL,
    is_correct  BOOLEAN NOT NULL DEFAULT false,
    order_index INTEGER NOT NULL
);

CREATE TABLE quiz_attempts (
    id             UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        UUID         NOT NULL REFERENCES users(id),
    quiz_id        UUID         NOT NULL REFERENCES quizzes(id),
    score          NUMERIC(5,2),
    passed         BOOLEAN,
    attempt_number INTEGER      NOT NULL DEFAULT 1,
    submitted_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Group 5 — Journal

CREATE TABLE journal_entries (
    id                   UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id              UUID          NOT NULL REFERENCES users(id),
    stage_id             UUID          REFERENCES stages(id),
    journal_type         TEXT          NOT NULL CHECK (journal_type IN ('learning', 'execution', 'performance')),
    pair                 TEXT,
    direction            TEXT,
    trade_date           DATE,
    session              TEXT,
    setup_type           TEXT,
    market_bias          TEXT,
    market_condition     TEXT,
    planned_entry        NUMERIC(20,8),
    planned_sl           NUMERIC(20,8),
    planned_tp           NUMERIC(20,8),
    actual_entry         NUMERIC(20,8),
    actual_exit          NUMERIC(20,8),
    risk_percent         NUMERIC(5,2),
    rr_planned           NUMERIC(10,4),
    rr_achieved          NUMERIC(10,4),
    result               TEXT,
    confidence_before    INTEGER,
    emotion_before       TEXT,
    emotion_during       TEXT,
    emotion_after        TEXT,
    followed_plan        BOOLEAN,
    risk_rule_followed   BOOLEAN,
    what_went_well       TEXT,
    what_went_wrong      TEXT,
    lessons_learned      TEXT,
    improvement_plan     TEXT,
    chart_screenshot_url TEXT,
    status               TEXT          NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'reviewed', 'flagged')),
    submitted_at         TIMESTAMPTZ,
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at           TIMESTAMPTZ   NOT NULL DEFAULT now()
);

CREATE TABLE journal_tags (
    id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name     TEXT NOT NULL UNIQUE,
    category TEXT
);

CREATE TABLE journal_entry_tags (
    id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_entry_id UUID NOT NULL REFERENCES journal_entries(id),
    journal_tag_id   UUID NOT NULL REFERENCES journal_tags(id)
);

CREATE TABLE risk_plans (
    id                     UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                UUID          NOT NULL REFERENCES users(id),
    stage_id               UUID          REFERENCES stages(id),
    max_risk_percent       NUMERIC(5,2),
    max_daily_loss_percent NUMERIC(5,2),
    max_weekly_loss_percent NUMERIC(5,2),
    rules_text             TEXT,
    submitted_at           TIMESTAMPTZ,
    approved_at            TIMESTAMPTZ,
    approved_by            UUID          REFERENCES users(id)
);

CREATE TABLE trade_datasets (
    id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID         NOT NULL REFERENCES users(id),
    stage_id     UUID         REFERENCES stages(id),
    dataset_name TEXT,
    trade_count  INTEGER,
    win_rate     NUMERIC(5,2),
    average_rr   NUMERIC(10,4),
    expectancy   NUMERIC(10,4),
    max_drawdown NUMERIC(5,2),
    review_text  TEXT,
    submitted_at TIMESTAMPTZ,
    reviewed_at  TIMESTAMPTZ,
    status       TEXT
);

-- Group 6 — AI Review

CREATE TABLE ai_reviews (
    id                        UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    journal_entry_id          UUID         NOT NULL UNIQUE REFERENCES journal_entries(id),
    user_id                   UUID         NOT NULL REFERENCES users(id),
    completeness_score        NUMERIC(5,2),
    risk_discipline_score     NUMERIC(5,2),
    reflection_quality_score  NUMERIC(5,2),
    process_compliance_score  NUMERIC(5,2),
    consistency_score         NUMERIC(5,2),
    overall_score             NUMERIC(5,2),
    feedback_summary          TEXT,
    missing_fields_json       JSONB,
    risk_flags_json           JSONB,
    reflection_feedback       TEXT,
    behaviour_pattern_feedback TEXT,
    prohibited_advice_detected BOOLEAN     NOT NULL DEFAULT false,
    model_version             TEXT,
    created_at                TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE ai_review_flags (
    id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    ai_review_id UUID        NOT NULL REFERENCES ai_reviews(id),
    flag_type    TEXT        NOT NULL CHECK (flag_type IN ('missing_data', 'risk_violation', 'weak_reflection', 'repeated_pattern', 'behaviour_decline')),
    severity     TEXT        NOT NULL CHECK (severity IN ('low', 'medium', 'high')),
    message      TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Group 8 — Certification (certificates)

CREATE TABLE certificates (
    id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID        NOT NULL REFERENCES users(id),
    certificate_type_id UUID        NOT NULL REFERENCES certificate_types(id),
    certificate_uid     TEXT        NOT NULL UNIQUE,
    identity_id         UUID        REFERENCES identities(id),
    issued_stage_id     UUID        REFERENCES stages(id),
    status              TEXT        NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'revoked', 'expired')),
    issue_date          DATE        NOT NULL DEFAULT CURRENT_DATE,
    verification_url    TEXT,
    revoked_at          TIMESTAMPTZ,
    revoked_reason      TEXT,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Group 7 — Progression

CREATE TABLE progression_rules (
    id                          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    stage_id                    UUID         NOT NULL REFERENCES stages(id),
    required_quiz_score         NUMERIC(5,2),
    required_journal_count      INTEGER,
    required_trade_plan_count   INTEGER,
    required_dataset_trade_count INTEGER,
    min_completeness_score      NUMERIC(5,2),
    min_risk_score              NUMERIC(5,2),
    min_reflection_score        NUMERIC(5,2),
    min_process_score           NUMERIC(5,2),
    max_recent_risk_violations  INTEGER,
    requires_risk_plan          BOOLEAN      NOT NULL DEFAULT false,
    requires_manual_review      BOOLEAN      NOT NULL DEFAULT false,
    certificate_type_id         UUID         REFERENCES certificate_types(id),
    unlocks_stage_id            UUID         REFERENCES stages(id),
    created_at                  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE stage_progress (
    id                      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 UUID         NOT NULL REFERENCES users(id),
    stage_id                UUID         NOT NULL REFERENCES stages(id),
    status                  TEXT         NOT NULL DEFAULT 'locked' CHECK (status IN ('locked', 'available', 'in_progress', 'pending_review', 'completed')),
    lesson_completion_percent NUMERIC(5,2) NOT NULL DEFAULT 0,
    quiz_passed             BOOLEAN      NOT NULL DEFAULT false,
    journal_requirement_met BOOLEAN      NOT NULL DEFAULT false,
    behaviour_requirement_met BOOLEAN    NOT NULL DEFAULT false,
    manual_review_status    TEXT         CHECK (manual_review_status IN ('pending', 'approved', 'rejected', 'revision_required')),
    completion_percentage   NUMERIC(5,2) NOT NULL DEFAULT 0,
    started_at              TIMESTAMPTZ,
    completed_at            TIMESTAMPTZ,
    updated_at              TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (user_id, stage_id)
);

CREATE TABLE identity_progress (
    id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID        NOT NULL REFERENCES users(id),
    identity_id     UUID        NOT NULL REFERENCES identities(id),
    status          TEXT        NOT NULL CHECK (status IN ('current', 'achieved', 'future')),
    achieved_at     TIMESTAMPTZ,
    source_stage_id UUID        REFERENCES stages(id),
    UNIQUE (user_id, identity_id)
);

CREATE TABLE capability_scores (
    id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID         NOT NULL REFERENCES users(id),
    capability_id UUID         NOT NULL REFERENCES capabilities(id),
    stage_id      UUID         REFERENCES stages(id),
    score         NUMERIC(5,2),
    source        TEXT         NOT NULL CHECK (source IN ('quiz', 'journal', 'manual_review', 'system')),
    calculated_at TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE progression_events (
    id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id        UUID        NOT NULL REFERENCES users(id),
    event_type     TEXT        NOT NULL,
    stage_id       UUID        REFERENCES stages(id),
    identity_id    UUID        REFERENCES identities(id),
    certificate_id UUID        REFERENCES certificates(id),
    message        TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Group 9 — Admin Review & Audit

CREATE TABLE manual_reviews (
    id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL REFERENCES users(id),
    stage_id    UUID         REFERENCES stages(id),
    reviewer_id UUID         REFERENCES users(id),
    review_type TEXT         NOT NULL CHECK (review_type IN ('stage_5_5_dataset_review', 'stage_7_framework_review', 'admin_override')),
    status      TEXT         NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'revision_required')),
    score       NUMERIC(5,2),
    feedback    TEXT,
    reviewed_at TIMESTAMPTZ,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE admin_overrides (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID        NOT NULL REFERENCES users(id),
    admin_id    UUID        NOT NULL REFERENCES users(id),
    target_type TEXT        NOT NULL,
    target_id   UUID        NOT NULL,
    action      TEXT        NOT NULL,
    reason      TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE activity_logs (
    id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       UUID        REFERENCES users(id),
    actor_id      UUID        REFERENCES users(id),
    action        TEXT        NOT NULL,
    entity_type   TEXT,
    entity_id     UUID,
    metadata_json JSONB,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- Indexes
-- ============================================================

-- user_id
CREATE INDEX idx_user_profiles_user_id       ON user_profiles(user_id);
CREATE INDEX idx_lesson_completions_user_id  ON lesson_completions(user_id);
CREATE INDEX idx_quiz_attempts_user_id       ON quiz_attempts(user_id);
CREATE INDEX idx_journal_entries_user_id     ON journal_entries(user_id);
CREATE INDEX idx_risk_plans_user_id          ON risk_plans(user_id);
CREATE INDEX idx_trade_datasets_user_id      ON trade_datasets(user_id);
CREATE INDEX idx_ai_reviews_user_id          ON ai_reviews(user_id);
CREATE INDEX idx_certificates_user_id        ON certificates(user_id);
CREATE INDEX idx_stage_progress_user_id      ON stage_progress(user_id);
CREATE INDEX idx_identity_progress_user_id   ON identity_progress(user_id);
CREATE INDEX idx_capability_scores_user_id   ON capability_scores(user_id);
CREATE INDEX idx_progression_events_user_id  ON progression_events(user_id);
CREATE INDEX idx_manual_reviews_user_id      ON manual_reviews(user_id);
CREATE INDEX idx_admin_overrides_user_id     ON admin_overrides(user_id);
CREATE INDEX idx_activity_logs_user_id       ON activity_logs(user_id);

-- stage_id
CREATE INDEX idx_stages_course_id                   ON stages(course_id);
CREATE INDEX idx_stage_capabilities_stage_id        ON stage_capabilities(stage_id);
CREATE INDEX idx_modules_stage_id                   ON modules(stage_id);
CREATE INDEX idx_quizzes_stage_id                   ON quizzes(stage_id);
CREATE INDEX idx_journal_entries_stage_id           ON journal_entries(stage_id);
CREATE INDEX idx_risk_plans_stage_id                ON risk_plans(stage_id);
CREATE INDEX idx_trade_datasets_stage_id            ON trade_datasets(stage_id);
CREATE INDEX idx_progression_rules_stage_id         ON progression_rules(stage_id);
CREATE INDEX idx_stage_progress_stage_id            ON stage_progress(stage_id);
CREATE INDEX idx_identity_progress_source_stage_id  ON identity_progress(source_stage_id);
CREATE INDEX idx_capability_scores_stage_id         ON capability_scores(stage_id);
CREATE INDEX idx_progression_events_stage_id        ON progression_events(stage_id);
CREATE INDEX idx_manual_reviews_stage_id            ON manual_reviews(stage_id);

-- lesson_id
CREATE INDEX idx_lesson_completions_lesson_id ON lesson_completions(lesson_id);
CREATE INDEX idx_quizzes_lesson_id            ON quizzes(lesson_id);

-- quiz_id
CREATE INDEX idx_questions_quiz_id     ON questions(quiz_id);
CREATE INDEX idx_quiz_attempts_quiz_id ON quiz_attempts(quiz_id);

-- journal_entry_id
CREATE INDEX idx_ai_reviews_journal_entry_id          ON ai_reviews(journal_entry_id);
CREATE INDEX idx_journal_entry_tags_journal_entry_id  ON journal_entry_tags(journal_entry_id);
