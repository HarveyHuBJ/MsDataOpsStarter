CREATE USER [AppSP] FROM EXTERNAL PROVIDER;

-- or db_owner
EXEC sp_addrolemember 'db_datawriter', [AppSP];

-- to grant other user using [AppSp]
GRANT ALTER ANY USER TO [AppSp];


-- az CLI
-- az sql server ad-admin