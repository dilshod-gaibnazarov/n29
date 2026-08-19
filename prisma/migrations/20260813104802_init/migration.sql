-- CreateEnum
CREATE TYPE "user_status" AS ENUM ('ACTIVE', 'INACTIVE', 'BLOCKED', 'PENDING');

-- CreateEnum
CREATE TYPE "organization_status" AS ENUM ('TRIAL', 'ACTIVE', 'GRACE_PERIOD', 'SUSPENDED', 'CLOSED');

-- CreateEnum
CREATE TYPE "branch_status" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "membership_status" AS ENUM ('INVITED', 'ACTIVE', 'SUSPENDED', 'LEFT');

-- CreateEnum
CREATE TYPE "permission_scope" AS ENUM ('OWN', 'BRANCH', 'ORGANIZATION', 'PLATFORM');

-- CreateEnum
CREATE TYPE "room_status" AS ENUM ('ACTIVE', 'MAINTENANCE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "employee_status" AS ENUM ('ACTIVE', 'ON_LEAVE', 'TERMINATED');

-- CreateEnum
CREATE TYPE "salary_scheme_status" AS ENUM ('DRAFT', 'ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "salary_rule_type" AS ENUM ('FIXED', 'PER_LESSON', 'PER_HOUR', 'PER_STUDENT', 'REVENUE_PERCENTAGE', 'BONUS', 'PENALTY', 'CUSTOM_FORMULA');

-- CreateEnum
CREATE TYPE "payroll_period_status" AS ENUM ('OPEN', 'CALCULATING', 'CALCULATED', 'APPROVED', 'PAID', 'LOCKED');

-- CreateEnum
CREATE TYPE "payroll_item_status" AS ENUM ('DRAFT', 'APPROVED', 'PAID', 'CANCELLED');

-- CreateEnum
CREATE TYPE "lead_stage_type" AS ENUM ('OPEN', 'WON', 'LOST');

-- CreateEnum
CREATE TYPE "lead_activity_type" AS ENUM ('CALL', 'MESSAGE', 'MEETING', 'NOTE', 'TASK', 'TRIAL_LESSON', 'STATUS_CHANGE');

-- CreateEnum
CREATE TYPE "lead_task_status" AS ENUM ('PENDING', 'DONE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "trial_lesson_status" AS ENUM ('SCHEDULED', 'ATTENDED', 'MISSED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "student_status" AS ENUM ('ACTIVE', 'FROZEN', 'GRADUATED', 'DROPPED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "gender_type" AS ENUM ('MALE', 'FEMALE');

-- CreateEnum
CREATE TYPE "parent_relation_type" AS ENUM ('MOTHER', 'FATHER', 'GUARDIAN', 'OTHER');

-- CreateEnum
CREATE TYPE "course_status" AS ENUM ('DRAFT', 'ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "course_version_status" AS ENUM ('DRAFT', 'ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "material_type" AS ENUM ('TEXT', 'VIDEO', 'FILE', 'LINK', 'CODE');

-- CreateEnum
CREATE TYPE "group_status" AS ENUM ('PLANNED', 'ACTIVE', 'FINISHED', 'FROZEN', 'CANCELLED');

-- CreateEnum
CREATE TYPE "group_teacher_role" AS ENUM ('MAIN', 'ASSISTANT', 'SUBSTITUTE');

-- CreateEnum
CREATE TYPE "enrollment_status" AS ENUM ('ACTIVE', 'FROZEN', 'TRANSFERRED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "lesson_session_status" AS ENUM ('PLANNED', 'COMPLETED', 'CANCELLED', 'RESCHEDULED');

-- CreateEnum
CREATE TYPE "attendance_status" AS ENUM ('PRESENT', 'ABSENT', 'LATE', 'EXCUSED');

-- CreateEnum
CREATE TYPE "submission_status" AS ENUM ('DRAFT', 'SUBMITTED', 'LATE', 'REVIEWED', 'RETURNED');

-- CreateEnum
CREATE TYPE "invoice_lifecycle_status" AS ENUM ('DRAFT', 'ISSUED', 'VOID');

-- CreateEnum
CREATE TYPE "payment_method" AS ENUM ('CASH', 'CARD', 'BANK_TRANSFER', 'ONLINE');

-- CreateEnum
CREATE TYPE "payment_status" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "payment_intent_status" AS ENUM ('CREATED', 'PENDING', 'PAID', 'FAILED', 'EXPIRED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "webhook_status" AS ENUM ('RECEIVED', 'PROCESSED', 'FAILED', 'IGNORED');

-- CreateEnum
CREATE TYPE "refund_status" AS ENUM ('REQUESTED', 'APPROVED', 'REJECTED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "discount_type" AS ENUM ('PERCENTAGE', 'FIXED_AMOUNT');

-- CreateEnum
CREATE TYPE "ledger_direction" AS ENUM ('DEBIT', 'CREDIT');

-- CreateEnum
CREATE TYPE "ledger_entry_type" AS ENUM ('INVOICE_ISSUED', 'INVOICE_VOIDED', 'PAYMENT_RECEIVED', 'PAYMENT_ALLOCATED', 'DISCOUNT_APPLIED', 'REFUND', 'ADJUSTMENT', 'REVERSAL');

-- CreateEnum
CREATE TYPE "account_status" AS ENUM ('ACTIVE', 'CLOSED');

-- CreateEnum
CREATE TYPE "cashbox_type" AS ENUM ('CASH', 'BANK', 'CARD', 'ONLINE');

-- CreateEnum
CREATE TYPE "cashbox_status" AS ENUM ('ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "finance_category_type" AS ENUM ('INCOME', 'EXPENSE');

-- CreateEnum
CREATE TYPE "financial_period_status" AS ENUM ('OPEN', 'CLOSED');

-- CreateEnum
CREATE TYPE "plan_status" AS ENUM ('ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "subscription_status" AS ENUM ('ACTIVE', 'GRACE_PERIOD', 'SUSPENDED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "wallet_status" AS ENUM ('ACTIVE', 'FROZEN');

-- CreateEnum
CREATE TYPE "wallet_transaction_type" AS ENUM ('TOP_UP', 'SUBSCRIPTION_CHARGE', 'REFUND', 'BONUS', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "subscription_charge_status" AS ENUM ('PENDING', 'CHARGED', 'FAILED', 'WAIVED');

-- CreateEnum
CREATE TYPE "notification_channel" AS ENUM ('SMS', 'TELEGRAM', 'EMAIL', 'IN_APP', 'PUSH');

-- CreateEnum
CREATE TYPE "delivery_status" AS ENUM ('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'READ');

-- CreateEnum
CREATE TYPE "provider_account_status" AS ENUM ('ACTIVE', 'INACTIVE', 'ERROR');

-- CreateEnum
CREATE TYPE "report_job_status" AS ENUM ('QUEUED', 'PROCESSING', 'COMPLETED', 'FAILED', 'EXPIRED');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" VARCHAR,
    "phone" VARCHAR,
    "password_hash" TEXT NOT NULL,
    "status" "user_status" NOT NULL DEFAULT 'PENDING',
    "mfa_enabled" BOOLEAN NOT NULL DEFAULT false,
    "mfa_secret_encrypted" TEXT,
    "mfa_enrolled_at" TIMESTAMPTZ,
    "email_verified_at" TIMESTAMPTZ,
    "phone_verified_at" TIMESTAMPTZ,
    "last_login_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_mfa_recovery_codes" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "code_hash" TEXT NOT NULL,
    "used_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_mfa_recovery_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "refresh_token_hash" TEXT NOT NULL,
    "device_name" VARCHAR,
    "ip_address" VARCHAR,
    "user_agent" TEXT,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "revoked_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "platform_user_roles" (
    "user_id" UUID NOT NULL,
    "role_code" VARCHAR NOT NULL,
    "granted_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "platform_user_roles_pkey" PRIMARY KEY ("user_id","role_code")
);

-- CreateTable
CREATE TABLE "exchange_rates" (
    "id" UUID NOT NULL,
    "base_currency" VARCHAR(3) NOT NULL,
    "quote_currency" VARCHAR(3) NOT NULL,
    "rate" DECIMAL(18,8) NOT NULL,
    "valid_from" DATE NOT NULL,
    "source" VARCHAR,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exchange_rates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organizations" (
    "id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "slug" VARCHAR NOT NULL,
    "logo_file_id" UUID,
    "status" "organization_status" NOT NULL DEFAULT 'TRIAL',
    "timezone" VARCHAR NOT NULL DEFAULT 'Asia/Tashkent',
    "currency" VARCHAR(3) NOT NULL DEFAULT 'UZS',
    "language" VARCHAR(5) NOT NULL DEFAULT 'uz',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_settings" (
    "organization_id" UUID NOT NULL,
    "primary_color" VARCHAR(7),
    "support_email" VARCHAR,
    "support_phone" VARCHAR,
    "invoice_prefix" VARCHAR,
    "settings" JSONB NOT NULL DEFAULT '{}',
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "organization_settings_pkey" PRIMARY KEY ("organization_id")
);

-- CreateTable
CREATE TABLE "branches" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "address" TEXT,
    "phone" VARCHAR,
    "timezone" VARCHAR,
    "status" "branch_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "branches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_memberships" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "status" "membership_status" NOT NULL DEFAULT 'INVITED',
    "joined_at" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "organization_memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "code" VARCHAR,
    "is_system" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "organization_id" UUID NOT NULL,
    "role_id" UUID NOT NULL,
    "permission_code" VARCHAR NOT NULL,
    "scope" "permission_scope" NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("role_id","permission_code")
);

-- CreateTable
CREATE TABLE "membership_role_assignments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "membership_id" UUID NOT NULL,
    "role_id" UUID NOT NULL,
    "branch_id" UUID,
    "granted_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "membership_role_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rooms" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "branch_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "capacity" INTEGER,
    "status" "room_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "files" (
    "id" UUID NOT NULL,
    "organization_id" UUID,
    "storage_key" VARCHAR NOT NULL,
    "name" VARCHAR NOT NULL,
    "mime_type" VARCHAR NOT NULL,
    "size_bytes" BIGINT NOT NULL,
    "uploaded_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "files_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employees" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "user_id" UUID,
    "full_name" VARCHAR NOT NULL,
    "phone" VARCHAR,
    "email" VARCHAR,
    "position" VARCHAR,
    "status" "employee_status" NOT NULL DEFAULT 'ACTIVE',
    "hire_date" DATE,
    "terminated_at" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee_branch_assignments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "branch_id" UUID NOT NULL,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "starts_at" DATE,
    "ends_at" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "employee_branch_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "salary_schemes" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "status" "salary_scheme_status" NOT NULL DEFAULT 'DRAFT',
    "currency" VARCHAR(3) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "salary_schemes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "salary_rules" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "scheme_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "type" "salary_rule_type" NOT NULL,
    "priority" INTEGER NOT NULL,
    "base_amount" DECIMAL(18,2),
    "percentage" DECIMAL(9,4),
    "expression" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "salary_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee_salary_assignments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "scheme_id" UUID NOT NULL,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "employee_salary_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee_salary_rule_overrides" (
    "organization_id" UUID NOT NULL,
    "scheme_id" UUID NOT NULL,
    "assignment_id" UUID NOT NULL,
    "salary_rule_id" UUID NOT NULL,
    "base_amount" DECIMAL(18,2),
    "percentage" DECIMAL(9,4),
    "expression" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "employee_salary_rule_overrides_pkey" PRIMARY KEY ("assignment_id","salary_rule_id")
);

-- CreateTable
CREATE TABLE "payroll_periods" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "status" "payroll_period_status" NOT NULL DEFAULT 'OPEN',
    "approved_by" UUID,
    "approved_at" TIMESTAMPTZ,
    "locked_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payroll_periods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_items" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "payroll_period_id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "total_amount" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "status" "payroll_item_status" NOT NULL DEFAULT 'DRAFT',
    "paid_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payroll_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payroll_item_components" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "payroll_item_id" UUID NOT NULL,
    "salary_rule_id" UUID,
    "rule_type" "salary_rule_type",
    "expression_snapshot" TEXT,
    "input_snapshot" JSONB,
    "label" VARCHAR NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payroll_item_components_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_sources" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "code" VARCHAR,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_sources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_pipelines" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_pipelines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_stages" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "pipeline_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "position" INTEGER NOT NULL,
    "type" "lead_stage_type" NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_stages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_lost_reasons" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_lost_reasons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leads" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "branch_id" UUID,
    "full_name" VARCHAR NOT NULL,
    "phone" VARCHAR NOT NULL,
    "email" VARCHAR,
    "source_id" UUID,
    "pipeline_id" UUID NOT NULL,
    "stage_id" UUID NOT NULL,
    "manager_id" UUID,
    "interested_course_id" UUID,
    "lost_reason_id" UUID,
    "converted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "leads_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_activities" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "lead_id" UUID NOT NULL,
    "actor_id" UUID,
    "type" "lead_activity_type" NOT NULL,
    "content" TEXT,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_activities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lead_tasks" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "lead_id" UUID NOT NULL,
    "assignee_id" UUID NOT NULL,
    "title" VARCHAR NOT NULL,
    "due_at" TIMESTAMPTZ NOT NULL,
    "status" "lead_task_status" NOT NULL DEFAULT 'PENDING',
    "completed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trial_lessons" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "lead_id" UUID NOT NULL,
    "branch_id" UUID NOT NULL,
    "group_id" UUID,
    "scheduled_at" TIMESTAMPTZ NOT NULL,
    "status" "trial_lesson_status" NOT NULL DEFAULT 'SCHEDULED',
    "result" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "trial_lessons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "students" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "user_id" UUID,
    "converted_from_lead_id" UUID,
    "full_name" VARCHAR NOT NULL,
    "phone" VARCHAR,
    "birth_date" DATE,
    "gender" "gender_type",
    "current_status" "student_status" NOT NULL DEFAULT 'ACTIVE',
    "joined_at" DATE NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_status_history" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "status" "student_status" NOT NULL,
    "reason" TEXT,
    "changed_by" UUID,
    "valid_from" TIMESTAMPTZ NOT NULL,
    "valid_to" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_status_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "parents" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "user_id" UUID,
    "full_name" VARCHAR NOT NULL,
    "phone" VARCHAR,
    "email" VARCHAR,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "parents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_parents" (
    "organization_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "parent_id" UUID NOT NULL,
    "relation_type" "parent_relation_type" NOT NULL,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "receive_notifications" BOOLEAN NOT NULL DEFAULT true,
    "can_view_finance" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_parents_pkey" PRIMARY KEY ("student_id","parent_id")
);

-- CreateTable
CREATE TABLE "course_categories" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "course_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "courses" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "category_id" UUID,
    "name" VARCHAR NOT NULL,
    "status" "course_status" NOT NULL DEFAULT 'DRAFT',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "courses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course_versions" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "course_id" UUID NOT NULL,
    "version" INTEGER NOT NULL,
    "duration_weeks" INTEGER,
    "total_lessons" INTEGER,
    "base_price" DECIMAL(18,2),
    "currency" VARCHAR(3) NOT NULL,
    "status" "course_version_status" NOT NULL DEFAULT 'DRAFT',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "course_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "curriculum_modules" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "course_version_id" UUID NOT NULL,
    "title" VARCHAR NOT NULL,
    "position" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "curriculum_modules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "curriculum_topics" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "module_id" UUID NOT NULL,
    "title" VARCHAR NOT NULL,
    "position" INTEGER NOT NULL,
    "estimated_minutes" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "curriculum_topics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "course_materials" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "topic_id" UUID NOT NULL,
    "type" "material_type" NOT NULL,
    "title" VARCHAR NOT NULL,
    "content" TEXT,
    "file_id" UUID,
    "url" TEXT,
    "position" INTEGER NOT NULL,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "course_materials_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "groups" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "branch_id" UUID NOT NULL,
    "course_version_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "start_date" DATE NOT NULL,
    "expected_end_date" DATE,
    "max_students" INTEGER,
    "status" "group_status" NOT NULL DEFAULT 'PLANNED',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_teachers" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "employee_id" UUID NOT NULL,
    "role" "group_teacher_role" NOT NULL DEFAULT 'MAIN',
    "starts_at" DATE,
    "ends_at" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "group_teachers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_enrollments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "joined_at" DATE NOT NULL,
    "left_at" DATE,
    "status" "enrollment_status" NOT NULL DEFAULT 'ACTIVE',
    "price_override" DECIMAL(18,2),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "group_enrollments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_group_transfers" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "from_enrollment_id" UUID NOT NULL,
    "to_enrollment_id" UUID NOT NULL,
    "reason" TEXT,
    "transferred_at" TIMESTAMPTZ NOT NULL,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_group_transfers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "holidays" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "branch_id" UUID,
    "name" VARCHAR NOT NULL,
    "date" DATE NOT NULL,
    "is_working_day" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "holidays_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "schedules" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "room_id" UUID,
    "weekday" INTEGER NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "effective_from" DATE NOT NULL,
    "effective_to" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lesson_sessions" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "schedule_id" UUID,
    "room_id" UUID,
    "topic_id" UUID,
    "starts_at" TIMESTAMPTZ NOT NULL,
    "ends_at" TIMESTAMPTZ NOT NULL,
    "status" "lesson_session_status" NOT NULL DEFAULT 'PLANNED',
    "rescheduled_from_session_id" UUID,
    "cancel_reason" TEXT,
    "cancelled_by" UUID,
    "cancelled_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lesson_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendances" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "lesson_session_id" UUID NOT NULL,
    "group_enrollment_id" UUID NOT NULL,
    "status" "attendance_status" NOT NULL,
    "arrival_time" TIMESTAMPTZ,
    "comment" TEXT,
    "marked_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attendances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "certificates" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_enrollment_id" UUID NOT NULL,
    "file_id" UUID,
    "certificate_no" VARCHAR NOT NULL,
    "issued_at" DATE NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "certificates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "topic_id" UUID,
    "title" VARCHAR NOT NULL,
    "description" TEXT,
    "deadline" TIMESTAMPTZ,
    "max_score" DECIMAL(10,2),
    "published_at" TIMESTAMPTZ,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assignment_files" (
    "organization_id" UUID NOT NULL,
    "assignment_id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "assignment_files_pkey" PRIMARY KEY ("assignment_id","file_id")
);

-- CreateTable
CREATE TABLE "assignment_submissions" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_id" UUID NOT NULL,
    "assignment_id" UUID NOT NULL,
    "group_enrollment_id" UUID NOT NULL,
    "text" TEXT,
    "status" "submission_status" NOT NULL DEFAULT 'DRAFT',
    "submitted_at" TIMESTAMPTZ,
    "score" DECIMAL(10,2),
    "feedback" TEXT,
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "assignment_submissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "submission_files" (
    "organization_id" UUID NOT NULL,
    "submission_id" UUID NOT NULL,
    "file_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "submission_files_pkey" PRIMARY KEY ("submission_id","file_id")
);

-- CreateTable
CREATE TABLE "student_accounts" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "status" "account_status" NOT NULL DEFAULT 'ACTIVE',
    "balance_cached" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "balance_cached_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_ledger_entries" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "entry_type" "ledger_entry_type" NOT NULL,
    "direction" "ledger_direction" NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "invoice_id" UUID,
    "payment_id" UUID,
    "payment_allocation_id" UUID,
    "refund_id" UUID,
    "discount_assignment_id" UUID,
    "reversal_of_entry_id" UUID,
    "description" TEXT,
    "created_by" UUID,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_ledger_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_payment_plans" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "group_enrollment_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "total_amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "status" VARCHAR NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_payment_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "student_payment_plan_installments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "payment_plan_id" UUID NOT NULL,
    "installment_no" INTEGER NOT NULL,
    "due_date" DATE NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "student_payment_plan_installments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "number" VARCHAR NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "issue_date" DATE NOT NULL,
    "due_date" DATE,
    "lifecycle_status" "invoice_lifecycle_status" NOT NULL DEFAULT 'DRAFT',
    "voided_at" TIMESTAMPTZ,
    "void_reason" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice_items" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "invoice_id" UUID NOT NULL,
    "item_code" VARCHAR NOT NULL,
    "description" VARCHAR NOT NULL,
    "quantity" DECIMAL(18,4) NOT NULL,
    "unit_price" DECIMAL(18,2) NOT NULL,
    "payment_plan_installment_id" UUID,
    "discount_assignment_id" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invoice_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "student_id" UUID NOT NULL,
    "cashbox_id" UUID,
    "branch_id" UUID,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "method" "payment_method" NOT NULL,
    "status" "payment_status" NOT NULL DEFAULT 'PENDING',
    "paid_at" TIMESTAMPTZ NOT NULL,
    "provider_intent_id" UUID,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_allocations" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "payment_id" UUID NOT NULL,
    "invoice_id" UUID NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_allocations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refunds" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "account_id" UUID NOT NULL,
    "payment_id" UUID NOT NULL,
    "cashbox_id" UUID,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "reason" TEXT,
    "status" "refund_status" NOT NULL DEFAULT 'REQUESTED',
    "approved_by" UUID,
    "refunded_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refunds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refund_allocations" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "refund_id" UUID NOT NULL,
    "invoice_id" UUID NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refund_allocations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discounts" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "type" "discount_type" NOT NULL,
    "value" DECIMAL(18,4) NOT NULL,
    "valid_from" DATE,
    "valid_to" DATE,
    "status" VARCHAR NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "discounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discount_assignments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "discount_id" UUID NOT NULL,
    "group_enrollment_id" UUID NOT NULL,
    "approved_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "discount_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_provider_accounts" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "provider" VARCHAR NOT NULL,
    "merchant_ref" VARCHAR,
    "credentials_encrypted" TEXT NOT NULL,
    "status" "provider_account_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_provider_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_intents" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "provider_account_id" UUID NOT NULL,
    "student_id" UUID,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "idempotency_key" VARCHAR NOT NULL,
    "provider_tx_id" VARCHAR,
    "status" "payment_intent_status" NOT NULL DEFAULT 'CREATED',
    "expires_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_intents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_webhooks" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "provider_account_id" UUID NOT NULL,
    "provider_event_id" VARCHAR,
    "signature_valid" BOOLEAN NOT NULL,
    "payload" JSONB NOT NULL,
    "status" "webhook_status" NOT NULL DEFAULT 'RECEIVED',
    "error_message" TEXT,
    "received_at" TIMESTAMPTZ NOT NULL,
    "processed_at" TIMESTAMPTZ,

    CONSTRAINT "payment_webhooks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cashboxes" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "type" "cashbox_type" NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "status" "cashbox_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cashboxes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cashbox_branch_scopes" (
    "organization_id" UUID NOT NULL,
    "cashbox_id" UUID NOT NULL,
    "branch_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cashbox_branch_scopes_pkey" PRIMARY KEY ("cashbox_id")
);

-- CreateTable
CREATE TABLE "finance_categories" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "type" "finance_category_type" NOT NULL,
    "name" VARCHAR NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "finance_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "other_incomes" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "branch_id" UUID,
    "cashbox_id" UUID NOT NULL,
    "category_id" UUID NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "description" TEXT,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "other_incomes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expenses" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "branch_id" UUID,
    "cashbox_id" UUID NOT NULL,
    "category_id" UUID NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "description" TEXT,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cashbox_transfers" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "from_cashbox_id" UUID NOT NULL,
    "to_cashbox_id" UUID NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "exchange_rate" DECIMAL(18,8),
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cashbox_transfers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "financial_periods" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "status" "financial_period_status" NOT NULL DEFAULT 'OPEN',
    "closed_at" TIMESTAMPTZ,
    "closed_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "financial_periods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plans" (
    "id" UUID NOT NULL,
    "name" VARCHAR NOT NULL,
    "code" VARCHAR NOT NULL,
    "monthly_price" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "status" "plan_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plan_features" (
    "plan_id" UUID NOT NULL,
    "feature_key" VARCHAR NOT NULL,
    "limit_value" DECIMAL(18,4),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "plan_features_pkey" PRIMARY KEY ("plan_id","feature_key")
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "plan_id" UUID NOT NULL,
    "status" "subscription_status" NOT NULL DEFAULT 'ACTIVE',
    "grace_period_days" INTEGER NOT NULL DEFAULT 7,
    "started_at" TIMESTAMPTZ NOT NULL,
    "current_period_start" DATE NOT NULL,
    "current_period_end" DATE NOT NULL,
    "cancelled_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_plan_changes" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "subscription_id" UUID NOT NULL,
    "from_plan_id" UUID,
    "to_plan_id" UUID NOT NULL,
    "reason" TEXT,
    "changed_by" UUID,
    "effective_from" DATE NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscription_plan_changes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "platform_wallets" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "balance_cached" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "status" "wallet_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "platform_wallets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "platform_wallet_transactions" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "wallet_id" UUID NOT NULL,
    "type" "wallet_transaction_type" NOT NULL,
    "direction" "ledger_direction" NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "description" TEXT,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "platform_wallet_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_charges" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "subscription_id" UUID NOT NULL,
    "plan_id" UUID NOT NULL,
    "period_start" DATE NOT NULL,
    "period_end" DATE NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "status" "subscription_charge_status" NOT NULL DEFAULT 'PENDING',
    "wallet_tx_id" UUID,
    "failure_reason" TEXT,
    "charged_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscription_charges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "platform_payments" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "wallet_id" UUID NOT NULL,
    "wallet_tx_id" UUID,
    "amount" DECIMAL(18,2) NOT NULL,
    "currency" VARCHAR(3) NOT NULL,
    "method" "payment_method" NOT NULL,
    "provider_tx_id" VARCHAR,
    "status" "payment_status" NOT NULL DEFAULT 'PENDING',
    "paid_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "platform_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "communication_provider_accounts" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "channel" "notification_channel" NOT NULL,
    "provider" VARCHAR NOT NULL,
    "credentials_encrypted" TEXT NOT NULL,
    "status" "provider_account_status" NOT NULL DEFAULT 'ACTIVE',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "communication_provider_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_templates" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "event_key" VARCHAR NOT NULL,
    "channel" "notification_channel" NOT NULL,
    "language" VARCHAR(5) NOT NULL,
    "subject" VARCHAR,
    "body" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_preferences" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "membership_id" UUID NOT NULL,
    "event_key" VARCHAR NOT NULL,
    "channel" "notification_channel" NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "event_key" VARCHAR NOT NULL,
    "recipient_user_id" UUID,
    "recipient_address" VARCHAR,
    "payload" JSONB NOT NULL,
    "scheduled_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_deliveries" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "notification_id" UUID NOT NULL,
    "channel" "notification_channel" NOT NULL,
    "provider_account_id" UUID,
    "provider_message_id" VARCHAR,
    "status" "delivery_status" NOT NULL DEFAULT 'PENDING',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "last_error" TEXT,
    "sent_at" TIMESTAMPTZ,
    "delivered_at" TIMESTAMPTZ,
    "read_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notification_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "telegram_user_links" (
    "id" UUID NOT NULL,
    "organization_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "provider_account_id" UUID NOT NULL,
    "telegram_chat_id" VARCHAR NOT NULL,
    "verified_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "telegram_user_links_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "report_jobs" (
    "id" UUID NOT NULL,
    "organization_id" UUID,
    "requested_by" UUID NOT NULL,
    "report_type" VARCHAR NOT NULL,
    "filters" JSONB NOT NULL,
    "status" "report_job_status" NOT NULL DEFAULT 'QUEUED',
    "file_id" UUID,
    "error_message" TEXT,
    "expires_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completed_at" TIMESTAMPTZ,

    CONSTRAINT "report_jobs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "outbox_events" (
    "id" UUID NOT NULL,
    "organization_id" UUID,
    "topic" VARCHAR NOT NULL,
    "version" INTEGER NOT NULL,
    "aggregate_type" VARCHAR NOT NULL,
    "aggregate_id" UUID NOT NULL,
    "payload" JSONB NOT NULL,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "published_at" TIMESTAMPTZ,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "last_error" TEXT,

    CONSTRAINT "outbox_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "idempotency_keys" (
    "id" UUID NOT NULL,
    "organization_id" UUID,
    "scope" VARCHAR NOT NULL,
    "key" VARCHAR NOT NULL,
    "request_hash" VARCHAR,
    "response_code" INTEGER,
    "response_body" JSONB,
    "expires_at" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "idempotency_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "organization_id" UUID,
    "branch_id" UUID,
    "actor_user_id" UUID,
    "action" VARCHAR NOT NULL,
    "entity_type" VARCHAR NOT NULL,
    "entity_id" UUID,
    "old_value" JSONB,
    "new_value" JSONB,
    "request_id" VARCHAR,
    "ip_address" VARCHAR,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "user_mfa_recovery_codes_user_id_code_hash_key" ON "user_mfa_recovery_codes"("user_id", "code_hash");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_refresh_token_hash_key" ON "user_sessions"("refresh_token_hash");

-- CreateIndex
CREATE INDEX "user_sessions_user_id_expires_at_idx" ON "user_sessions"("user_id", "expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "exchange_rates_base_currency_quote_currency_valid_from_key" ON "exchange_rates"("base_currency", "quote_currency", "valid_from");

-- CreateIndex
CREATE UNIQUE INDEX "organizations_slug_key" ON "organizations"("slug");

-- CreateIndex
CREATE INDEX "branches_organization_id_status_idx" ON "branches"("organization_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "branches_organization_id_name_key" ON "branches"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "branches_tenant_uq" ON "branches"("organization_id", "id");

-- CreateIndex
CREATE INDEX "organization_memberships_user_id_status_idx" ON "organization_memberships"("user_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "organization_memberships_organization_id_user_id_key" ON "organization_memberships"("organization_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "memberships_tenant_uq" ON "organization_memberships"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "roles_organization_id_name_key" ON "roles"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "roles_tenant_uq" ON "roles"("organization_id", "id");

-- CreateIndex
CREATE INDEX "role_permissions_organization_id_role_id_idx" ON "role_permissions"("organization_id", "role_id");

-- CreateIndex
CREATE INDEX "membership_role_assignments_organization_id_membership_id_idx" ON "membership_role_assignments"("organization_id", "membership_id");

-- CreateIndex
CREATE INDEX "membership_role_assignments_organization_id_role_id_idx" ON "membership_role_assignments"("organization_id", "role_id");

-- CreateIndex
CREATE UNIQUE INDEX "rooms_branch_id_name_key" ON "rooms"("branch_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "rooms_tenant_uq" ON "rooms"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "files_storage_key_key" ON "files"("storage_key");

-- CreateIndex
CREATE INDEX "files_organization_id_created_at_idx" ON "files"("organization_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "files_tenant_uq" ON "files"("organization_id", "id");

-- CreateIndex
CREATE INDEX "employees_organization_id_status_idx" ON "employees"("organization_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "employees_org_phone_uq" ON "employees"("organization_id", "phone");

-- CreateIndex
CREATE UNIQUE INDEX "employees_tenant_uq" ON "employees"("organization_id", "id");

-- CreateIndex
CREATE INDEX "employee_branch_assignments_organization_id_branch_id_idx" ON "employee_branch_assignments"("organization_id", "branch_id");

-- CreateIndex
CREATE UNIQUE INDEX "employee_branch_assignments_employee_id_branch_id_starts_at_key" ON "employee_branch_assignments"("employee_id", "branch_id", "starts_at");

-- CreateIndex
CREATE UNIQUE INDEX "salary_schemes_organization_id_name_key" ON "salary_schemes"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "salary_schemes_tenant_uq" ON "salary_schemes"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "salary_rules_scheme_id_priority_key" ON "salary_rules"("scheme_id", "priority");

-- CreateIndex
CREATE UNIQUE INDEX "salary_rules_scheme_uq" ON "salary_rules"("organization_id", "scheme_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "employee_salary_assignments_employee_id_effective_from_key" ON "employee_salary_assignments"("employee_id", "effective_from");

-- CreateIndex
CREATE UNIQUE INDEX "esa_scheme_uq" ON "employee_salary_assignments"("organization_id", "scheme_id", "id");

-- CreateIndex
CREATE INDEX "payroll_periods_organization_id_status_idx" ON "payroll_periods"("organization_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_periods_org_start_uq" ON "payroll_periods"("organization_id", "period_start");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_periods_tenant_uq" ON "payroll_periods"("organization_id", "id");

-- CreateIndex
CREATE INDEX "payroll_items_organization_id_employee_id_status_idx" ON "payroll_items"("organization_id", "employee_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_items_payroll_period_id_employee_id_key" ON "payroll_items"("payroll_period_id", "employee_id");

-- CreateIndex
CREATE UNIQUE INDEX "payroll_items_tenant_uq" ON "payroll_items"("organization_id", "id");

-- CreateIndex
CREATE INDEX "payroll_item_components_organization_id_payroll_item_id_idx" ON "payroll_item_components"("organization_id", "payroll_item_id");

-- CreateIndex
CREATE UNIQUE INDEX "lead_sources_organization_id_name_key" ON "lead_sources"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "lead_sources_tenant_uq" ON "lead_sources"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "lead_pipelines_organization_id_name_key" ON "lead_pipelines"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "lead_pipelines_tenant_uq" ON "lead_pipelines"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "lead_stages_pipeline_id_position_key" ON "lead_stages"("pipeline_id", "position");

-- CreateIndex
CREATE UNIQUE INDEX "lead_stages_pipeline_name_uq" ON "lead_stages"("pipeline_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "lead_stages_tenant_uq" ON "lead_stages"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "lead_lost_reasons_org_name_uq" ON "lead_lost_reasons"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "lead_lost_reasons_tenant_uq" ON "lead_lost_reasons"("organization_id", "id");

-- CreateIndex
CREATE INDEX "leads_organization_id_created_at_idx" ON "leads"("organization_id", "created_at");

-- CreateIndex
CREATE INDEX "leads_organization_id_stage_id_idx" ON "leads"("organization_id", "stage_id");

-- CreateIndex
CREATE INDEX "leads_organization_id_manager_id_created_at_idx" ON "leads"("organization_id", "manager_id", "created_at");

-- CreateIndex
CREATE INDEX "leads_organization_id_branch_id_created_at_idx" ON "leads"("organization_id", "branch_id", "created_at");

-- CreateIndex
CREATE INDEX "leads_organization_id_phone_idx" ON "leads"("organization_id", "phone");

-- CreateIndex
CREATE INDEX "leads_organization_id_converted_at_idx" ON "leads"("organization_id", "converted_at");

-- CreateIndex
CREATE UNIQUE INDEX "leads_tenant_uq" ON "leads"("organization_id", "id");

-- CreateIndex
CREATE INDEX "lead_activities_organization_id_lead_id_occurred_at_idx" ON "lead_activities"("organization_id", "lead_id", "occurred_at");

-- CreateIndex
CREATE INDEX "lead_tasks_organization_id_assignee_id_status_due_at_idx" ON "lead_tasks"("organization_id", "assignee_id", "status", "due_at");

-- CreateIndex
CREATE INDEX "lead_tasks_organization_id_lead_id_idx" ON "lead_tasks"("organization_id", "lead_id");

-- CreateIndex
CREATE INDEX "trial_lessons_organization_id_scheduled_at_idx" ON "trial_lessons"("organization_id", "scheduled_at");

-- CreateIndex
CREATE INDEX "trial_lessons_organization_id_lead_id_idx" ON "trial_lessons"("organization_id", "lead_id");

-- CreateIndex
CREATE INDEX "students_organization_id_current_status_idx" ON "students"("organization_id", "current_status");

-- CreateIndex
CREATE INDEX "students_organization_id_created_at_idx" ON "students"("organization_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "students_org_phone_uq" ON "students"("organization_id", "phone");

-- CreateIndex
CREATE UNIQUE INDEX "students_tenant_uq" ON "students"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "students_from_lead_uq" ON "students"("organization_id", "converted_from_lead_id");

-- CreateIndex
CREATE INDEX "student_status_history_student_id_valid_to_idx" ON "student_status_history"("student_id", "valid_to");

-- CreateIndex
CREATE INDEX "student_status_history_organization_id_status_idx" ON "student_status_history"("organization_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "student_status_history_student_id_valid_from_key" ON "student_status_history"("student_id", "valid_from");

-- CreateIndex
CREATE UNIQUE INDEX "parents_org_phone_uq" ON "parents"("organization_id", "phone");

-- CreateIndex
CREATE UNIQUE INDEX "parents_tenant_uq" ON "parents"("organization_id", "id");

-- CreateIndex
CREATE INDEX "student_parents_organization_id_parent_id_idx" ON "student_parents"("organization_id", "parent_id");

-- CreateIndex
CREATE UNIQUE INDEX "course_categories_organization_id_name_key" ON "course_categories"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "course_categories_tenant_uq" ON "course_categories"("organization_id", "id");

-- CreateIndex
CREATE INDEX "courses_organization_id_status_idx" ON "courses"("organization_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "courses_organization_id_name_key" ON "courses"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "courses_tenant_uq" ON "courses"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "course_versions_course_id_version_key" ON "course_versions"("course_id", "version");

-- CreateIndex
CREATE UNIQUE INDEX "course_versions_tenant_uq" ON "course_versions"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "curriculum_modules_course_version_id_position_key" ON "curriculum_modules"("course_version_id", "position");

-- CreateIndex
CREATE UNIQUE INDEX "curriculum_modules_tenant_uq" ON "curriculum_modules"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "curriculum_topics_module_id_position_key" ON "curriculum_topics"("module_id", "position");

-- CreateIndex
CREATE UNIQUE INDEX "curriculum_topics_tenant_uq" ON "curriculum_topics"("organization_id", "id");

-- CreateIndex
CREATE INDEX "course_materials_organization_id_topic_id_idx" ON "course_materials"("organization_id", "topic_id");

-- CreateIndex
CREATE UNIQUE INDEX "course_materials_topic_id_position_key" ON "course_materials"("topic_id", "position");

-- CreateIndex
CREATE INDEX "groups_organization_id_status_idx" ON "groups"("organization_id", "status");

-- CreateIndex
CREATE INDEX "groups_organization_id_branch_id_status_idx" ON "groups"("organization_id", "branch_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "groups_organization_id_branch_id_name_key" ON "groups"("organization_id", "branch_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "groups_tenant_uq" ON "groups"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "groups_branch_uq" ON "groups"("organization_id", "branch_id", "id");

-- CreateIndex
CREATE INDEX "group_teachers_organization_id_employee_id_idx" ON "group_teachers"("organization_id", "employee_id");

-- CreateIndex
CREATE UNIQUE INDEX "group_teachers_uq" ON "group_teachers"("group_id", "employee_id", "role", "starts_at");

-- CreateIndex
CREATE INDEX "group_enrollments_organization_id_student_id_status_idx" ON "group_enrollments"("organization_id", "student_id", "status");

-- CreateIndex
CREATE INDEX "group_enrollments_organization_id_group_id_status_idx" ON "group_enrollments"("organization_id", "group_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "group_enrollments_group_id_student_id_key" ON "group_enrollments"("group_id", "student_id");

-- CreateIndex
CREATE UNIQUE INDEX "group_enrollments_tenant_uq" ON "group_enrollments"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "group_enrollments_group_uq" ON "group_enrollments"("organization_id", "group_id", "id");

-- CreateIndex
CREATE INDEX "student_group_transfers_organization_id_student_id_transfer_idx" ON "student_group_transfers"("organization_id", "student_id", "transferred_at");

-- CreateIndex
CREATE UNIQUE INDEX "student_group_transfers_from_enrollment_id_to_enrollment_id_key" ON "student_group_transfers"("from_enrollment_id", "to_enrollment_id");

-- CreateIndex
CREATE UNIQUE INDEX "holidays_organization_id_branch_id_date_key" ON "holidays"("organization_id", "branch_id", "date");

-- CreateIndex
CREATE INDEX "schedules_organization_id_group_id_effective_from_idx" ON "schedules"("organization_id", "group_id", "effective_from");

-- CreateIndex
CREATE INDEX "schedules_room_id_weekday_idx" ON "schedules"("room_id", "weekday");

-- CreateIndex
CREATE UNIQUE INDEX "schedules_tenant_uq" ON "schedules"("organization_id", "id");

-- CreateIndex
CREATE INDEX "lesson_sessions_organization_id_group_id_starts_at_idx" ON "lesson_sessions"("organization_id", "group_id", "starts_at");

-- CreateIndex
CREATE INDEX "lesson_sessions_organization_id_starts_at_idx" ON "lesson_sessions"("organization_id", "starts_at");

-- CreateIndex
CREATE INDEX "lesson_sessions_room_id_starts_at_idx" ON "lesson_sessions"("room_id", "starts_at");

-- CreateIndex
CREATE UNIQUE INDEX "lesson_sessions_tenant_uq" ON "lesson_sessions"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "lesson_sessions_group_uq" ON "lesson_sessions"("organization_id", "group_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "lesson_sessions_reschedule_uq" ON "lesson_sessions"("rescheduled_from_session_id");

-- CreateIndex
CREATE INDEX "attendances_organization_id_group_enrollment_id_idx" ON "attendances"("organization_id", "group_enrollment_id");

-- CreateIndex
CREATE INDEX "attendances_organization_id_status_created_at_idx" ON "attendances"("organization_id", "status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "attendances_lesson_session_id_group_enrollment_id_key" ON "attendances"("lesson_session_id", "group_enrollment_id");

-- CreateIndex
CREATE UNIQUE INDEX "certificates_org_no_uq" ON "certificates"("organization_id", "certificate_no");

-- CreateIndex
CREATE UNIQUE INDEX "certificates_group_enrollment_id_key" ON "certificates"("group_enrollment_id");

-- CreateIndex
CREATE INDEX "assignments_organization_id_group_id_deadline_idx" ON "assignments"("organization_id", "group_id", "deadline");

-- CreateIndex
CREATE UNIQUE INDEX "assignments_tenant_uq" ON "assignments"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "assignments_group_uq" ON "assignments"("organization_id", "group_id", "id");

-- CreateIndex
CREATE INDEX "assignment_submissions_organization_id_status_submitted_at_idx" ON "assignment_submissions"("organization_id", "status", "submitted_at");

-- CreateIndex
CREATE UNIQUE INDEX "assignment_submissions_assignment_id_group_enrollment_id_key" ON "assignment_submissions"("assignment_id", "group_enrollment_id");

-- CreateIndex
CREATE UNIQUE INDEX "submissions_tenant_uq" ON "assignment_submissions"("organization_id", "id");

-- CreateIndex
CREATE INDEX "student_accounts_organization_id_balance_cached_idx" ON "student_accounts"("organization_id", "balance_cached");

-- CreateIndex
CREATE UNIQUE INDEX "student_accounts_organization_id_student_id_currency_key" ON "student_accounts"("organization_id", "student_id", "currency");

-- CreateIndex
CREATE UNIQUE INDEX "student_accounts_tenant_uq" ON "student_accounts"("organization_id", "id");

-- CreateIndex
CREATE INDEX "student_ledger_entries_organization_id_account_id_occurred__idx" ON "student_ledger_entries"("organization_id", "account_id", "occurred_at");

-- CreateIndex
CREATE INDEX "student_ledger_entries_organization_id_entry_type_occurred__idx" ON "student_ledger_entries"("organization_id", "entry_type", "occurred_at");

-- CreateIndex
CREATE UNIQUE INDEX "ledger_reversal_uq" ON "student_ledger_entries"("reversal_of_entry_id");

-- CreateIndex
CREATE INDEX "student_payment_plans_group_enrollment_id_idx" ON "student_payment_plans"("group_enrollment_id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_plans_tenant_uq" ON "student_payment_plans"("organization_id", "id");

-- CreateIndex
CREATE INDEX "student_payment_plan_installments_organization_id_due_date_idx" ON "student_payment_plan_installments"("organization_id", "due_date");

-- CreateIndex
CREATE UNIQUE INDEX "student_payment_plan_installments_payment_plan_id_installme_key" ON "student_payment_plan_installments"("payment_plan_id", "installment_no");

-- CreateIndex
CREATE UNIQUE INDEX "installments_tenant_uq" ON "student_payment_plan_installments"("organization_id", "id");

-- CreateIndex
CREATE INDEX "invoices_organization_id_student_id_issue_date_idx" ON "invoices"("organization_id", "student_id", "issue_date");

-- CreateIndex
CREATE INDEX "invoices_organization_id_lifecycle_status_due_date_idx" ON "invoices"("organization_id", "lifecycle_status", "due_date");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_org_number_uq" ON "invoices"("organization_id", "number");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_tenant_uq" ON "invoices"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_account_uq" ON "invoices"("organization_id", "account_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "invoice_items_payment_plan_installment_id_key" ON "invoice_items"("payment_plan_installment_id");

-- CreateIndex
CREATE INDEX "invoice_items_organization_id_invoice_id_idx" ON "invoice_items"("organization_id", "invoice_id");

-- CreateIndex
CREATE INDEX "payments_organization_id_paid_at_idx" ON "payments"("organization_id", "paid_at");

-- CreateIndex
CREATE INDEX "payments_organization_id_student_id_paid_at_idx" ON "payments"("organization_id", "student_id", "paid_at");

-- CreateIndex
CREATE INDEX "payments_organization_id_cashbox_id_paid_at_idx" ON "payments"("organization_id", "cashbox_id", "paid_at");

-- CreateIndex
CREATE UNIQUE INDEX "payments_tenant_uq" ON "payments"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "payments_account_uq" ON "payments"("organization_id", "account_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "payments_intent_uq" ON "payments"("provider_intent_id");

-- CreateIndex
CREATE INDEX "payment_allocations_organization_id_invoice_id_idx" ON "payment_allocations"("organization_id", "invoice_id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_allocations_payment_id_invoice_id_key" ON "payment_allocations"("payment_id", "invoice_id");

-- CreateIndex
CREATE INDEX "refunds_organization_id_payment_id_idx" ON "refunds"("organization_id", "payment_id");

-- CreateIndex
CREATE UNIQUE INDEX "refunds_tenant_uq" ON "refunds"("organization_id", "id");

-- CreateIndex
CREATE INDEX "refund_allocations_organization_id_invoice_id_idx" ON "refund_allocations"("organization_id", "invoice_id");

-- CreateIndex
CREATE UNIQUE INDEX "refund_allocations_refund_id_invoice_id_key" ON "refund_allocations"("refund_id", "invoice_id");

-- CreateIndex
CREATE UNIQUE INDEX "discounts_org_name_uq" ON "discounts"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "discounts_tenant_uq" ON "discounts"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "discount_assignments_uq" ON "discount_assignments"("discount_id", "group_enrollment_id");

-- CreateIndex
CREATE UNIQUE INDEX "discount_assignments_tenant_uq" ON "discount_assignments"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_provider_accounts_organization_id_provider_key" ON "payment_provider_accounts"("organization_id", "provider");

-- CreateIndex
CREATE UNIQUE INDEX "ppa_tenant_uq" ON "payment_provider_accounts"("organization_id", "id");

-- CreateIndex
CREATE INDEX "payment_intents_organization_id_status_created_at_idx" ON "payment_intents"("organization_id", "status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "payment_intents_provider_account_id_idempotency_key_key" ON "payment_intents"("provider_account_id", "idempotency_key");

-- CreateIndex
CREATE UNIQUE INDEX "payment_intents_provider_account_id_provider_tx_id_key" ON "payment_intents"("provider_account_id", "provider_tx_id");

-- CreateIndex
CREATE UNIQUE INDEX "payment_intents_tenant_uq" ON "payment_intents"("organization_id", "id");

-- CreateIndex
CREATE INDEX "payment_webhooks_organization_id_status_received_at_idx" ON "payment_webhooks"("organization_id", "status", "received_at");

-- CreateIndex
CREATE UNIQUE INDEX "payment_webhooks_provider_account_id_provider_event_id_key" ON "payment_webhooks"("provider_account_id", "provider_event_id");

-- CreateIndex
CREATE UNIQUE INDEX "cashboxes_organization_id_name_key" ON "cashboxes"("organization_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "cashboxes_tenant_uq" ON "cashboxes"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "finance_categories_organization_id_type_name_key" ON "finance_categories"("organization_id", "type", "name");

-- CreateIndex
CREATE UNIQUE INDEX "finance_categories_tenant_uq" ON "finance_categories"("organization_id", "id");

-- CreateIndex
CREATE INDEX "other_incomes_organization_id_occurred_at_idx" ON "other_incomes"("organization_id", "occurred_at");

-- CreateIndex
CREATE INDEX "other_incomes_organization_id_cashbox_id_occurred_at_idx" ON "other_incomes"("organization_id", "cashbox_id", "occurred_at");

-- CreateIndex
CREATE INDEX "other_incomes_organization_id_category_id_idx" ON "other_incomes"("organization_id", "category_id");

-- CreateIndex
CREATE INDEX "expenses_organization_id_occurred_at_idx" ON "expenses"("organization_id", "occurred_at");

-- CreateIndex
CREATE INDEX "expenses_organization_id_cashbox_id_occurred_at_idx" ON "expenses"("organization_id", "cashbox_id", "occurred_at");

-- CreateIndex
CREATE INDEX "expenses_organization_id_category_id_idx" ON "expenses"("organization_id", "category_id");

-- CreateIndex
CREATE INDEX "cashbox_transfers_organization_id_occurred_at_idx" ON "cashbox_transfers"("organization_id", "occurred_at");

-- CreateIndex
CREATE UNIQUE INDEX "financial_periods_org_start_uq" ON "financial_periods"("organization_id", "period_start");

-- CreateIndex
CREATE UNIQUE INDEX "plans_code_key" ON "plans"("code");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_organization_id_key" ON "subscriptions"("organization_id");

-- CreateIndex
CREATE INDEX "subscriptions_status_current_period_end_idx" ON "subscriptions"("status", "current_period_end");

-- CreateIndex
CREATE INDEX "subscription_plan_changes_organization_id_effective_from_idx" ON "subscription_plan_changes"("organization_id", "effective_from");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_plan_changes_subscription_id_effective_from_key" ON "subscription_plan_changes"("subscription_id", "effective_from");

-- CreateIndex
CREATE UNIQUE INDEX "platform_wallets_organization_id_key" ON "platform_wallets"("organization_id");

-- CreateIndex
CREATE INDEX "platform_wallet_transactions_wallet_id_occurred_at_idx" ON "platform_wallet_transactions"("wallet_id", "occurred_at");

-- CreateIndex
CREATE INDEX "platform_wallet_transactions_organization_id_type_occurred__idx" ON "platform_wallet_transactions"("organization_id", "type", "occurred_at");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_charges_wallet_tx_id_key" ON "subscription_charges"("wallet_tx_id");

-- CreateIndex
CREATE INDEX "subscription_charges_organization_id_status_period_start_idx" ON "subscription_charges"("organization_id", "status", "period_start");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_charges_period_uq" ON "subscription_charges"("subscription_id", "period_start");

-- CreateIndex
CREATE UNIQUE INDEX "platform_payments_wallet_tx_id_key" ON "platform_payments"("wallet_tx_id");

-- CreateIndex
CREATE INDEX "platform_payments_organization_id_paid_at_idx" ON "platform_payments"("organization_id", "paid_at");

-- CreateIndex
CREATE UNIQUE INDEX "communication_provider_accounts_organization_id_channel_pro_key" ON "communication_provider_accounts"("organization_id", "channel", "provider");

-- CreateIndex
CREATE UNIQUE INDEX "cpa_tenant_uq" ON "communication_provider_accounts"("organization_id", "id");

-- CreateIndex
CREATE UNIQUE INDEX "cpa_channel_uq" ON "communication_provider_accounts"("organization_id", "id", "channel");

-- CreateIndex
CREATE UNIQUE INDEX "notification_templates_organization_id_event_key_channel_la_key" ON "notification_templates"("organization_id", "event_key", "channel", "language");

-- CreateIndex
CREATE INDEX "notification_preferences_organization_id_membership_id_idx" ON "notification_preferences"("organization_id", "membership_id");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_membership_id_event_key_channel_key" ON "notification_preferences"("membership_id", "event_key", "channel");

-- CreateIndex
CREATE INDEX "notifications_organization_id_event_key_created_at_idx" ON "notifications"("organization_id", "event_key", "created_at");

-- CreateIndex
CREATE INDEX "notifications_recipient_user_id_created_at_idx" ON "notifications"("recipient_user_id", "created_at");

-- CreateIndex
CREATE INDEX "notifications_scheduled_at_idx" ON "notifications"("scheduled_at");

-- CreateIndex
CREATE UNIQUE INDEX "notifications_tenant_uq" ON "notifications"("organization_id", "id");

-- CreateIndex
CREATE INDEX "notification_deliveries_organization_id_status_created_at_idx" ON "notification_deliveries"("organization_id", "status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "notification_deliveries_notification_id_channel_key" ON "notification_deliveries"("notification_id", "channel");

-- CreateIndex
CREATE UNIQUE INDEX "telegram_user_links_user_id_provider_account_id_key" ON "telegram_user_links"("user_id", "provider_account_id");

-- CreateIndex
CREATE UNIQUE INDEX "telegram_user_links_provider_account_id_telegram_chat_id_key" ON "telegram_user_links"("provider_account_id", "telegram_chat_id");

-- CreateIndex
CREATE INDEX "report_jobs_organization_id_status_created_at_idx" ON "report_jobs"("organization_id", "status", "created_at");

-- CreateIndex
CREATE INDEX "report_jobs_expires_at_idx" ON "report_jobs"("expires_at");

-- CreateIndex
CREATE INDEX "outbox_events_aggregate_type_aggregate_id_occurred_at_idx" ON "outbox_events"("aggregate_type", "aggregate_id", "occurred_at");

-- CreateIndex
CREATE INDEX "outbox_events_topic_occurred_at_idx" ON "outbox_events"("topic", "occurred_at");

-- CreateIndex
CREATE INDEX "idempotency_keys_expires_at_idx" ON "idempotency_keys"("expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "idempotency_scope_key_uq" ON "idempotency_keys"("scope", "key");

-- CreateIndex
CREATE INDEX "audit_logs_organization_id_entity_type_entity_id_created_at_idx" ON "audit_logs"("organization_id", "entity_type", "entity_id", "created_at");

-- CreateIndex
CREATE INDEX "audit_logs_organization_id_actor_user_id_created_at_idx" ON "audit_logs"("organization_id", "actor_user_id", "created_at");

-- CreateIndex
CREATE INDEX "audit_logs_request_id_idx" ON "audit_logs"("request_id");

-- AddForeignKey
ALTER TABLE "user_mfa_recovery_codes" ADD CONSTRAINT "user_mfa_recovery_codes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_user_roles" ADD CONSTRAINT "platform_user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_user_roles" ADD CONSTRAINT "platform_user_roles_granted_by_fkey" FOREIGN KEY ("granted_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_logo_file_id_fkey" FOREIGN KEY ("logo_file_id") REFERENCES "files"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_settings" ADD CONSTRAINT "organization_settings_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "branches" ADD CONSTRAINT "branches_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_memberships" ADD CONSTRAINT "organization_memberships_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_memberships" ADD CONSTRAINT "organization_memberships_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "roles" ADD CONSTRAINT "roles_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_organization_id_role_id_fkey" FOREIGN KEY ("organization_id", "role_id") REFERENCES "roles"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership_role_assignments" ADD CONSTRAINT "membership_role_assignments_organization_id_membership_id_fkey" FOREIGN KEY ("organization_id", "membership_id") REFERENCES "organization_memberships"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership_role_assignments" ADD CONSTRAINT "membership_role_assignments_organization_id_role_id_fkey" FOREIGN KEY ("organization_id", "role_id") REFERENCES "roles"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership_role_assignments" ADD CONSTRAINT "membership_role_assignments_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership_role_assignments" ADD CONSTRAINT "membership_role_assignments_granted_by_fkey" FOREIGN KEY ("granted_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rooms" ADD CONSTRAINT "rooms_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "files" ADD CONSTRAINT "files_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "files" ADD CONSTRAINT "files_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_branch_assignments" ADD CONSTRAINT "employee_branch_assignments_organization_id_employee_id_fkey" FOREIGN KEY ("organization_id", "employee_id") REFERENCES "employees"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_branch_assignments" ADD CONSTRAINT "employee_branch_assignments_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "salary_schemes" ADD CONSTRAINT "salary_schemes_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "salary_rules" ADD CONSTRAINT "salary_rules_organization_id_scheme_id_fkey" FOREIGN KEY ("organization_id", "scheme_id") REFERENCES "salary_schemes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_salary_assignments" ADD CONSTRAINT "employee_salary_assignments_organization_id_employee_id_fkey" FOREIGN KEY ("organization_id", "employee_id") REFERENCES "employees"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_salary_assignments" ADD CONSTRAINT "employee_salary_assignments_organization_id_scheme_id_fkey" FOREIGN KEY ("organization_id", "scheme_id") REFERENCES "salary_schemes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_salary_rule_overrides" ADD CONSTRAINT "employee_salary_rule_overrides_organization_id_scheme_id_a_fkey" FOREIGN KEY ("organization_id", "scheme_id", "assignment_id") REFERENCES "employee_salary_assignments"("organization_id", "scheme_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_salary_rule_overrides" ADD CONSTRAINT "employee_salary_rule_overrides_organization_id_scheme_id_s_fkey" FOREIGN KEY ("organization_id", "scheme_id", "salary_rule_id") REFERENCES "salary_rules"("organization_id", "scheme_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_periods" ADD CONSTRAINT "payroll_periods_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_periods" ADD CONSTRAINT "payroll_periods_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_items" ADD CONSTRAINT "payroll_items_organization_id_payroll_period_id_fkey" FOREIGN KEY ("organization_id", "payroll_period_id") REFERENCES "payroll_periods"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_items" ADD CONSTRAINT "payroll_items_organization_id_employee_id_fkey" FOREIGN KEY ("organization_id", "employee_id") REFERENCES "employees"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_item_components" ADD CONSTRAINT "payroll_item_components_organization_id_payroll_item_id_fkey" FOREIGN KEY ("organization_id", "payroll_item_id") REFERENCES "payroll_items"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payroll_item_components" ADD CONSTRAINT "payroll_item_components_salary_rule_id_fkey" FOREIGN KEY ("salary_rule_id") REFERENCES "salary_rules"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_sources" ADD CONSTRAINT "lead_sources_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_pipelines" ADD CONSTRAINT "lead_pipelines_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_stages" ADD CONSTRAINT "lead_stages_organization_id_pipeline_id_fkey" FOREIGN KEY ("organization_id", "pipeline_id") REFERENCES "lead_pipelines"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_lost_reasons" ADD CONSTRAINT "lead_lost_reasons_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_source_id_fkey" FOREIGN KEY ("organization_id", "source_id") REFERENCES "lead_sources"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_pipeline_id_fkey" FOREIGN KEY ("organization_id", "pipeline_id") REFERENCES "lead_pipelines"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_stage_id_fkey" FOREIGN KEY ("organization_id", "stage_id") REFERENCES "lead_stages"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_manager_id_fkey" FOREIGN KEY ("organization_id", "manager_id") REFERENCES "employees"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_interested_course_id_fkey" FOREIGN KEY ("organization_id", "interested_course_id") REFERENCES "courses"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leads" ADD CONSTRAINT "leads_organization_id_lost_reason_id_fkey" FOREIGN KEY ("organization_id", "lost_reason_id") REFERENCES "lead_lost_reasons"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_activities" ADD CONSTRAINT "lead_activities_organization_id_lead_id_fkey" FOREIGN KEY ("organization_id", "lead_id") REFERENCES "leads"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_activities" ADD CONSTRAINT "lead_activities_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_tasks" ADD CONSTRAINT "lead_tasks_organization_id_lead_id_fkey" FOREIGN KEY ("organization_id", "lead_id") REFERENCES "leads"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lead_tasks" ADD CONSTRAINT "lead_tasks_assignee_id_fkey" FOREIGN KEY ("assignee_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trial_lessons" ADD CONSTRAINT "trial_lessons_organization_id_lead_id_fkey" FOREIGN KEY ("organization_id", "lead_id") REFERENCES "leads"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trial_lessons" ADD CONSTRAINT "trial_lessons_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trial_lessons" ADD CONSTRAINT "trial_lessons_organization_id_branch_id_group_id_fkey" FOREIGN KEY ("organization_id", "branch_id", "group_id") REFERENCES "groups"("organization_id", "branch_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "students" ADD CONSTRAINT "students_organization_id_converted_from_lead_id_fkey" FOREIGN KEY ("organization_id", "converted_from_lead_id") REFERENCES "leads"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_status_history" ADD CONSTRAINT "student_status_history_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_status_history" ADD CONSTRAINT "student_status_history_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parents" ADD CONSTRAINT "parents_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "parents" ADD CONSTRAINT "parents_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_parents" ADD CONSTRAINT "student_parents_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_parents" ADD CONSTRAINT "student_parents_organization_id_parent_id_fkey" FOREIGN KEY ("organization_id", "parent_id") REFERENCES "parents"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_categories" ADD CONSTRAINT "course_categories_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "courses" ADD CONSTRAINT "courses_organization_id_category_id_fkey" FOREIGN KEY ("organization_id", "category_id") REFERENCES "course_categories"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_versions" ADD CONSTRAINT "course_versions_organization_id_course_id_fkey" FOREIGN KEY ("organization_id", "course_id") REFERENCES "courses"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "curriculum_modules" ADD CONSTRAINT "curriculum_modules_organization_id_course_version_id_fkey" FOREIGN KEY ("organization_id", "course_version_id") REFERENCES "course_versions"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "curriculum_topics" ADD CONSTRAINT "curriculum_topics_organization_id_module_id_fkey" FOREIGN KEY ("organization_id", "module_id") REFERENCES "curriculum_modules"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_materials" ADD CONSTRAINT "course_materials_organization_id_topic_id_fkey" FOREIGN KEY ("organization_id", "topic_id") REFERENCES "curriculum_topics"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "course_materials" ADD CONSTRAINT "course_materials_organization_id_file_id_fkey" FOREIGN KEY ("organization_id", "file_id") REFERENCES "files"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "groups" ADD CONSTRAINT "groups_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "groups" ADD CONSTRAINT "groups_organization_id_course_version_id_fkey" FOREIGN KEY ("organization_id", "course_version_id") REFERENCES "course_versions"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_teachers" ADD CONSTRAINT "group_teachers_organization_id_group_id_fkey" FOREIGN KEY ("organization_id", "group_id") REFERENCES "groups"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_teachers" ADD CONSTRAINT "group_teachers_organization_id_employee_id_fkey" FOREIGN KEY ("organization_id", "employee_id") REFERENCES "employees"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_enrollments" ADD CONSTRAINT "group_enrollments_organization_id_group_id_fkey" FOREIGN KEY ("organization_id", "group_id") REFERENCES "groups"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_enrollments" ADD CONSTRAINT "group_enrollments_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_group_transfers" ADD CONSTRAINT "student_group_transfers_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_group_transfers" ADD CONSTRAINT "student_group_transfers_organization_id_from_enrollment_id_fkey" FOREIGN KEY ("organization_id", "from_enrollment_id") REFERENCES "group_enrollments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_group_transfers" ADD CONSTRAINT "student_group_transfers_organization_id_to_enrollment_id_fkey" FOREIGN KEY ("organization_id", "to_enrollment_id") REFERENCES "group_enrollments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_group_transfers" ADD CONSTRAINT "student_group_transfers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "holidays" ADD CONSTRAINT "holidays_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "holidays" ADD CONSTRAINT "holidays_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedules" ADD CONSTRAINT "schedules_organization_id_group_id_fkey" FOREIGN KEY ("organization_id", "group_id") REFERENCES "groups"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "schedules" ADD CONSTRAINT "schedules_organization_id_room_id_fkey" FOREIGN KEY ("organization_id", "room_id") REFERENCES "rooms"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lesson_sessions" ADD CONSTRAINT "lesson_sessions_organization_id_group_id_fkey" FOREIGN KEY ("organization_id", "group_id") REFERENCES "groups"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lesson_sessions" ADD CONSTRAINT "lesson_sessions_organization_id_schedule_id_fkey" FOREIGN KEY ("organization_id", "schedule_id") REFERENCES "schedules"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lesson_sessions" ADD CONSTRAINT "lesson_sessions_organization_id_room_id_fkey" FOREIGN KEY ("organization_id", "room_id") REFERENCES "rooms"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lesson_sessions" ADD CONSTRAINT "lesson_sessions_organization_id_topic_id_fkey" FOREIGN KEY ("organization_id", "topic_id") REFERENCES "curriculum_topics"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lesson_sessions" ADD CONSTRAINT "lesson_sessions_organization_id_rescheduled_from_session_i_fkey" FOREIGN KEY ("organization_id", "rescheduled_from_session_id") REFERENCES "lesson_sessions"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lesson_sessions" ADD CONSTRAINT "lesson_sessions_cancelled_by_fkey" FOREIGN KEY ("cancelled_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendances" ADD CONSTRAINT "attendances_organization_id_group_id_lesson_session_id_fkey" FOREIGN KEY ("organization_id", "group_id", "lesson_session_id") REFERENCES "lesson_sessions"("organization_id", "group_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendances" ADD CONSTRAINT "attendances_organization_id_group_id_group_enrollment_id_fkey" FOREIGN KEY ("organization_id", "group_id", "group_enrollment_id") REFERENCES "group_enrollments"("organization_id", "group_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendances" ADD CONSTRAINT "attendances_marked_by_fkey" FOREIGN KEY ("marked_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificates" ADD CONSTRAINT "certificates_organization_id_group_enrollment_id_fkey" FOREIGN KEY ("organization_id", "group_enrollment_id") REFERENCES "group_enrollments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "certificates" ADD CONSTRAINT "certificates_organization_id_file_id_fkey" FOREIGN KEY ("organization_id", "file_id") REFERENCES "files"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_organization_id_group_id_fkey" FOREIGN KEY ("organization_id", "group_id") REFERENCES "groups"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_organization_id_topic_id_fkey" FOREIGN KEY ("organization_id", "topic_id") REFERENCES "curriculum_topics"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignments" ADD CONSTRAINT "assignments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_files" ADD CONSTRAINT "assignment_files_organization_id_assignment_id_fkey" FOREIGN KEY ("organization_id", "assignment_id") REFERENCES "assignments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_files" ADD CONSTRAINT "assignment_files_organization_id_file_id_fkey" FOREIGN KEY ("organization_id", "file_id") REFERENCES "files"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_organization_id_group_id_assignment_fkey" FOREIGN KEY ("organization_id", "group_id", "assignment_id") REFERENCES "assignments"("organization_id", "group_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_organization_id_group_id_group_enro_fkey" FOREIGN KEY ("organization_id", "group_id", "group_enrollment_id") REFERENCES "group_enrollments"("organization_id", "group_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assignment_submissions" ADD CONSTRAINT "assignment_submissions_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission_files" ADD CONSTRAINT "submission_files_organization_id_submission_id_fkey" FOREIGN KEY ("organization_id", "submission_id") REFERENCES "assignment_submissions"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission_files" ADD CONSTRAINT "submission_files_organization_id_file_id_fkey" FOREIGN KEY ("organization_id", "file_id") REFERENCES "files"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_accounts" ADD CONSTRAINT "student_accounts_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_organization_id_account_id_fkey" FOREIGN KEY ("organization_id", "account_id") REFERENCES "student_accounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_organization_id_invoice_id_fkey" FOREIGN KEY ("organization_id", "invoice_id") REFERENCES "invoices"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_organization_id_payment_id_fkey" FOREIGN KEY ("organization_id", "payment_id") REFERENCES "payments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_payment_allocation_id_fkey" FOREIGN KEY ("payment_allocation_id") REFERENCES "payment_allocations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_organization_id_refund_id_fkey" FOREIGN KEY ("organization_id", "refund_id") REFERENCES "refunds"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_organization_id_discount_assignment_fkey" FOREIGN KEY ("organization_id", "discount_assignment_id") REFERENCES "discount_assignments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_reversal_of_entry_id_fkey" FOREIGN KEY ("reversal_of_entry_id") REFERENCES "student_ledger_entries"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_ledger_entries" ADD CONSTRAINT "student_ledger_entries_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_payment_plans" ADD CONSTRAINT "student_payment_plans_organization_id_group_enrollment_id_fkey" FOREIGN KEY ("organization_id", "group_enrollment_id") REFERENCES "group_enrollments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "student_payment_plan_installments" ADD CONSTRAINT "student_payment_plan_installments_organization_id_payment__fkey" FOREIGN KEY ("organization_id", "payment_plan_id") REFERENCES "student_payment_plans"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_organization_id_account_id_fkey" FOREIGN KEY ("organization_id", "account_id") REFERENCES "student_accounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_items" ADD CONSTRAINT "invoice_items_organization_id_invoice_id_fkey" FOREIGN KEY ("organization_id", "invoice_id") REFERENCES "invoices"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_items" ADD CONSTRAINT "invoice_items_organization_id_payment_plan_installment_id_fkey" FOREIGN KEY ("organization_id", "payment_plan_installment_id") REFERENCES "student_payment_plan_installments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_items" ADD CONSTRAINT "invoice_items_organization_id_discount_assignment_id_fkey" FOREIGN KEY ("organization_id", "discount_assignment_id") REFERENCES "discount_assignments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_organization_id_account_id_fkey" FOREIGN KEY ("organization_id", "account_id") REFERENCES "student_accounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_organization_id_cashbox_id_fkey" FOREIGN KEY ("organization_id", "cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_organization_id_provider_intent_id_fkey" FOREIGN KEY ("organization_id", "provider_intent_id") REFERENCES "payment_intents"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocations" ADD CONSTRAINT "payment_allocations_organization_id_account_id_payment_id_fkey" FOREIGN KEY ("organization_id", "account_id", "payment_id") REFERENCES "payments"("organization_id", "account_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_allocations" ADD CONSTRAINT "payment_allocations_organization_id_account_id_invoice_id_fkey" FOREIGN KEY ("organization_id", "account_id", "invoice_id") REFERENCES "invoices"("organization_id", "account_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_organization_id_account_id_payment_id_fkey" FOREIGN KEY ("organization_id", "account_id", "payment_id") REFERENCES "payments"("organization_id", "account_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_organization_id_cashbox_id_fkey" FOREIGN KEY ("organization_id", "cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refunds" ADD CONSTRAINT "refunds_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund_allocations" ADD CONSTRAINT "refund_allocations_organization_id_refund_id_fkey" FOREIGN KEY ("organization_id", "refund_id") REFERENCES "refunds"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refund_allocations" ADD CONSTRAINT "refund_allocations_organization_id_invoice_id_fkey" FOREIGN KEY ("organization_id", "invoice_id") REFERENCES "invoices"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discounts" ADD CONSTRAINT "discounts_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discount_assignments" ADD CONSTRAINT "discount_assignments_organization_id_discount_id_fkey" FOREIGN KEY ("organization_id", "discount_id") REFERENCES "discounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discount_assignments" ADD CONSTRAINT "discount_assignments_organization_id_group_enrollment_id_fkey" FOREIGN KEY ("organization_id", "group_enrollment_id") REFERENCES "group_enrollments"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "discount_assignments" ADD CONSTRAINT "discount_assignments_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_provider_accounts" ADD CONSTRAINT "payment_provider_accounts_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_intents" ADD CONSTRAINT "payment_intents_organization_id_provider_account_id_fkey" FOREIGN KEY ("organization_id", "provider_account_id") REFERENCES "payment_provider_accounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_intents" ADD CONSTRAINT "payment_intents_organization_id_student_id_fkey" FOREIGN KEY ("organization_id", "student_id") REFERENCES "students"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_webhooks" ADD CONSTRAINT "payment_webhooks_organization_id_provider_account_id_fkey" FOREIGN KEY ("organization_id", "provider_account_id") REFERENCES "payment_provider_accounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cashboxes" ADD CONSTRAINT "cashboxes_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cashbox_branch_scopes" ADD CONSTRAINT "cashbox_branch_scopes_organization_id_cashbox_id_fkey" FOREIGN KEY ("organization_id", "cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cashbox_branch_scopes" ADD CONSTRAINT "cashbox_branch_scopes_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "finance_categories" ADD CONSTRAINT "finance_categories_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "other_incomes" ADD CONSTRAINT "other_incomes_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "other_incomes" ADD CONSTRAINT "other_incomes_organization_id_cashbox_id_fkey" FOREIGN KEY ("organization_id", "cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "other_incomes" ADD CONSTRAINT "other_incomes_organization_id_category_id_fkey" FOREIGN KEY ("organization_id", "category_id") REFERENCES "finance_categories"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "other_incomes" ADD CONSTRAINT "other_incomes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_organization_id_cashbox_id_fkey" FOREIGN KEY ("organization_id", "cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_organization_id_category_id_fkey" FOREIGN KEY ("organization_id", "category_id") REFERENCES "finance_categories"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expenses" ADD CONSTRAINT "expenses_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cashbox_transfers" ADD CONSTRAINT "cashbox_transfers_organization_id_from_cashbox_id_fkey" FOREIGN KEY ("organization_id", "from_cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cashbox_transfers" ADD CONSTRAINT "cashbox_transfers_organization_id_to_cashbox_id_fkey" FOREIGN KEY ("organization_id", "to_cashbox_id") REFERENCES "cashboxes"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cashbox_transfers" ADD CONSTRAINT "cashbox_transfers_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "financial_periods" ADD CONSTRAINT "financial_periods_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "financial_periods" ADD CONSTRAINT "financial_periods_closed_by_fkey" FOREIGN KEY ("closed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plan_features" ADD CONSTRAINT "plan_features_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscriptions" ADD CONSTRAINT "subscriptions_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_plan_changes" ADD CONSTRAINT "subscription_plan_changes_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_plan_changes" ADD CONSTRAINT "subscription_plan_changes_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_plan_changes" ADD CONSTRAINT "subscription_plan_changes_from_plan_id_fkey" FOREIGN KEY ("from_plan_id") REFERENCES "plans"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_plan_changes" ADD CONSTRAINT "subscription_plan_changes_to_plan_id_fkey" FOREIGN KEY ("to_plan_id") REFERENCES "plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_plan_changes" ADD CONSTRAINT "subscription_plan_changes_changed_by_fkey" FOREIGN KEY ("changed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_wallets" ADD CONSTRAINT "platform_wallets_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_wallet_transactions" ADD CONSTRAINT "platform_wallet_transactions_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "platform_wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_wallet_transactions" ADD CONSTRAINT "platform_wallet_transactions_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_wallet_transactions" ADD CONSTRAINT "platform_wallet_transactions_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_charges" ADD CONSTRAINT "subscription_charges_subscription_id_fkey" FOREIGN KEY ("subscription_id") REFERENCES "subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_charges" ADD CONSTRAINT "subscription_charges_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_charges" ADD CONSTRAINT "subscription_charges_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_charges" ADD CONSTRAINT "subscription_charges_wallet_tx_id_fkey" FOREIGN KEY ("wallet_tx_id") REFERENCES "platform_wallet_transactions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_payments" ADD CONSTRAINT "platform_payments_wallet_id_fkey" FOREIGN KEY ("wallet_id") REFERENCES "platform_wallets"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_payments" ADD CONSTRAINT "platform_payments_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_payments" ADD CONSTRAINT "platform_payments_wallet_tx_id_fkey" FOREIGN KEY ("wallet_tx_id") REFERENCES "platform_wallet_transactions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "communication_provider_accounts" ADD CONSTRAINT "communication_provider_accounts_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_templates" ADD CONSTRAINT "notification_templates_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_preferences" ADD CONSTRAINT "notification_preferences_organization_id_membership_id_fkey" FOREIGN KEY ("organization_id", "membership_id") REFERENCES "organization_memberships"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_recipient_user_id_fkey" FOREIGN KEY ("recipient_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_deliveries" ADD CONSTRAINT "notification_deliveries_organization_id_notification_id_fkey" FOREIGN KEY ("organization_id", "notification_id") REFERENCES "notifications"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_deliveries" ADD CONSTRAINT "notification_deliveries_organization_id_provider_account_i_fkey" FOREIGN KEY ("organization_id", "provider_account_id", "channel") REFERENCES "communication_provider_accounts"("organization_id", "id", "channel") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "telegram_user_links" ADD CONSTRAINT "telegram_user_links_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "telegram_user_links" ADD CONSTRAINT "telegram_user_links_organization_id_provider_account_id_fkey" FOREIGN KEY ("organization_id", "provider_account_id") REFERENCES "communication_provider_accounts"("organization_id", "id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_jobs" ADD CONSTRAINT "report_jobs_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_jobs" ADD CONSTRAINT "report_jobs_requested_by_fkey" FOREIGN KEY ("requested_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "report_jobs" ADD CONSTRAINT "report_jobs_organization_id_file_id_fkey" FOREIGN KEY ("organization_id", "file_id") REFERENCES "files"("organization_id", "id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "outbox_events" ADD CONSTRAINT "outbox_events_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "idempotency_keys" ADD CONSTRAINT "idempotency_keys_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_organization_id_fkey" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_organization_id_branch_id_fkey" FOREIGN KEY ("organization_id", "branch_id") REFERENCES "branches"("organization_id", "id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
