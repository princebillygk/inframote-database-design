-- liquibase formatted sql

/***************/
/* Changeset 6 */
/***************/

/* Optimized version */
-- changeset princebillygk:6
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
    password VARCHAR(512) NOT NULL,
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
CREATE TABLE IF NOT EXISTS issue (
    id BIGSERIAL PRIMARY KEY,
    issuer_id BIGINT NOT NULL,
    remote_controller_id BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    details TEXT NOT NULL,
    is_open BOOL NOT NULL default true,
    FOREIGN KEY (issuer_id) REFERENCES usr(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (remote_controller_id) REFERENCES remote_controller(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* Super User */
CREATE TABLE IF NOT EXISTS su (
    id BIGINT PRIMARY KEY,
    first_name VARCHAR(35) NOT NULL,
    last_name VARCHAR(35) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

/* Reported Users */
CREATE TABLE IF NOT EXISTS reported_usr (
    id BIGSERIAL PRIMARY KEY,
    issuer_id BIGINT,
    reported_usr_id BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    details TEXT NOT NULL,
    is_active BOOL NOT NULL default true,
    FOREIGN KEY (issuer_id) REFERENCES usr(id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (reported_usr_id) REFERENCES usr(id) ON DELETE CASCADE ON UPDATE CASCADE
);

/* Reported Remotes */
CREATE TABLE IF NOT EXISTS reported_remote (
    id BIGSERIAL PRIMARY KEY,
    issuer_id BIGINT,
    remote_controller_id BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    details TEXT NOT NULL,
    is_active BOOL NOT NULL default true,
    FOREIGN KEY (issuer_id) REFERENCES usr(id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (remote_controller_id) REFERENCES remote_controller(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- rollback DROP TABLE reported_usr;
-- rollback DROP TABLE reported_remote; 
-- rollback DROP TABLE su;
-- rollback DROP TABLE issue;
-- rollback DROP TABLE remote_controller;
-- rollback DROP TABLE device;
-- rollback DROP TABLE manufacturer;
-- rollback DROP TABLE usr_facebook_auth;
-- rollback DROP TABLE usr_google_auth;
-- rollback DROP TABLE usr_email_auth;
-- rollback DROP TABLE usr;
