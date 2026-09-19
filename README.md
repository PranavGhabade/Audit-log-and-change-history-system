# Immutable Audit Log & Change History System

A PostgreSQL-based Audit Log and Change History System that records who changed what, when, and why. The system uses database triggers, JSONB audit records, SHA-256 hash chaining, role-based access control, integrity verification, indexing, partitioning, and a FastAPI backend.

## Technology Stack

- PostgreSQL 18
- Python 3.13
- FastAPI
- SQLAlchemy
- Psycopg
- JWT Authentication
- bcrypt
- Pytest

## Main Features

- Employee, Product and Order management
- JWT-based authentication
- Role-based authorization
- Automatic database audit logging
- INSERT, UPDATE and DELETE history
- Old and new record values stored as JSONB
- SHA-256 hash chain for tamper detection
- Audit integrity verification
- Append-only audit log protection
- Audit reporting views
- Database indexing experiments
- Range partitioning experiments
- Automated API tests

## System Architecture

```text
Client
  |
  v
FastAPI
  |
  +---- JWT Authentication
  |
  +---- Role Authorization
  |
  v
PostgreSQL
  |
  +---- Employee
  +---- Product
  +---- App Order
  |
  v
Database Triggers
  |
  v
Audit Log
  |
  +---- Old Data
  +---- New Data
  +---- User
  +---- Timestamp
  +---- Change Reason
  +---- Transaction ID
  +---- Previous Hash
  +---- Current Hash