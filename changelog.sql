-- liquibase formatted sql

/* Initializing Database */

/***************/
/* Changeset 1 */
/***************/

-- changeset pricnebillygk:1
/* User: */
/* Any consumer who will create account on our application. */
CREATE TABLE IF NOT EXISTS usr (
    id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(35) NOT NULL,
    last_name VARCHAR(35) NOT NULL,
    contact_email VARCHAR(255) UNIQUE NOT NULL,
    bio VARCHAR(1024),
    website_url VARCHAR(255),
    image_url VARCHAR(255),
    allow_marketing_mail BOOLEAN
);

/* User Authentication */
/* Email */
CREATE TABLE IF NOT EXISTS usr_email_auth (
    email VARCHAR(255) PRIMARY KEY,
    pass VARCHAR(512) NOT NULL,
    usr_id BIGINT NOT NULL,
    FOREIGN KEY (usr_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE
);
/* Google */
CREATE TABLE IF NOT EXISTS usr_google_auth (
    account_id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    usr_id BIGINT NOT NULL,
    FOREIGN KEY (usr_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE
);
/* Facebook */
CREATE TABLE IF NOT EXISTS usr_facebook_auth (
    account_id VARCHAR(255) PRIMARY KEY,
    usr_id BIGINT NOT NULL,
    FOREIGN KEY (usr_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE
);



/* Manufacturer */
CREATE TABLE manufacturer (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(35) NOT NULL
);

/* Device */
CREATE TABLE device (
    id SERIAL PRIMARY KEY,
    title VARCHAR(35) NOT NULL,
    logo_url VARCHAR(255) NOT NULL,
    short_description VARCHAR(60) NOT NULL
);

/* Remote Controller */
CREATE TABLE remote_controller (
    id BIGSERIAL PRIMARY KEY,
    usr_id BIGINT NOT NULL,
    manufacturer_id BIGINT NOT NULL,
    device_id INT NOT NULL,
    device_name VARCHAR(35) UNIQUE NOT NULL,
    config text NOT NULL,
    FOREIGN KEY (usr_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (device_id) REFERENCES device(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

/* Issued Reported to the contributor */
CREATE TABLE IF NOT EXISTS issues (
    id BIGSERIAL PRIMARY KEY,
    issuer_id BIGINT NOT NULL,
    remote_controller_id BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    details TEXT NOT NULL,
    is_open BOOL NOT NULL default true,
    FOREIGN KEY (issuer_id) REFERENCES usr(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (remote_controller_id) REFERENCES remote_controller(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* Super User */
CREATE TABLE IF NOT EXISTS su (
    id BIGINT PRIMARY KEY,
    first_name VARCHAR(35) NOT NULL,
    last_name VARCHAR(35) NOT NULL,
    phone VARCHAR(20) NOT NULL
);

/* Reported Users */
CREATE TABLE IF NOT EXISTS reported_usr (
    id BIGSERIAL PRIMARY KEY,
    issuer_id BIGINT NOT NULL,
    reported_usr_id BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    details TEXT NOT NULL,
    is_active BOOL NOT NULL default true,
    FOREIGN KEY (issuer_id) REFERENCES usr(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (reported_usr_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* Reported Remotes */
CREATE TABLE IF NOT EXISTS report (
    id BIGSERIAL PRIMARY KEY,
    issuer_id BIGINT NOT NULL,
    remote_controller_id BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    details TEXT NOT NULL,
    is_active BOOL NOT NULL default true,
    FOREIGN KEY (issuer_id) REFERENCES usr(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (remote_controller_id) REFERENCES remote_controller(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/***************/
/* Changeset 2 */
/***************/

-- changeset princebillygk:2
ALTER TABLE report RENAME TO report_remote;

/***************/
/* Changeset 3 */
/***************/

-- changeset princebillygk:3
/* Password is more convenient I think */
ALTER TABLE usr_email_auth RENAME COLUMN pass to password;

/* Adding email to user table */
ALTER TABLE su ADD COLUMN email VARCHAR(255) NOT NULL;

/* Changing issue table fkey action */
ALTER TABLE issues
    DROP CONSTRAINT issues_issuer_id_fkey,
    ADD CONSTRAINT issues_issuer_id_fkey
        FOREIGN KEY (issuer_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE;

/* Changing issue table fkey action */
ALTER TABLE issues
    DROP CONSTRAINT issues_issuer_id_fkey,
    ADD CONSTRAINT issues_issuer_id_fkey
        FOREIGN KEY (issuer_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE;

/* Renaming report_remote to reported_remote */
ALTER TABLE report_remote
    RENAME TO reported_remote;

/* Chaging reported_remotes table fkey action*/
ALTER TABLE reported_remote
    ALTER COLUMN issuer_id DROP NOT NULL,
    DROP CONSTRAINT report_issuer_id_fkey,
    ADD CONSTRAINT reported_remote_issuer_id_fkey
        FOREIGN KEY (issuer_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE;

/* Chaging reported_usr table fkey action*/
ALTER TABLE reported_usr
    ALTER COLUMN issuer_id DROP NOT NULL,
    DROP CONSTRAINT reported_usr_issuer_id_fkey,
    ADD CONSTRAINT report_usr_issuer_id_fkey
        FOREIGN KEY (issuer_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE;

/***************/
/* Changeset 4 */
/***************/

-- changeset princebillyg:4

/* Chaing issues to issue */
ALTER TABLE issues RENAME TO issue;
