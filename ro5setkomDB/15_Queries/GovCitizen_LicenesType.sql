SELECT TOP (1000) [GovCitizens].national_id
      ,[first_name]
      ,[last_name]
      ,[postal_code]
      ,[is_eligible]
      , license_type_id
  FROM [ro5setkomDB].[Gov].[GovCitizens]
  FULL JOIN ro5setkomDB.Gov.GovLicenseRecords ON GovCitizens.national_id = GovLicenseRecords.national_id
