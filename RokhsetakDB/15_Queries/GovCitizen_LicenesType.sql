SELECT TOP (1000) [GovCitizens].national_id
      ,[first_name]
      ,[last_name]
      ,[postal_code]
      ,[is_eligible]
      , license_type_id
  FROM RokhsetakDB.Gov.GovCitizens
  FULL JOIN RokhsetakDB.Gov.GovLicenseRecords ON GovCitizens.national_id = GovLicenseRecords.national_id
