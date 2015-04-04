# in features/export-to-csv.feature
Feature: Export project info to CSV
  As the portal admin
  So that I can have project information in an easy-to-manipulate format
  I want to export all projects to a CSV file.

  Background:
    Given I am logged in as an administrator
    And the following clients exist:
    | company_name | company_site       | company_address | contact_email      | contact_number |
    | Client A     | http://clienta.org | 123 Client A Dr | client@clienta.org | N/A            |
    | Client B     | http://clientb.org | 123 Client B Dr | client@clientb.org | (408)-254-3682 |
    | Client C     | http://clientc.org | 123 Client C Dr | client@clientc.org | (408)-254-3683 |
    And the following projects exist:
    | title            | short_description | long_description | client   |
    | Client A project | short desc A      | long desc A      | Client A |
    | Client B project | short desc B      | long desc B      | Client B |
    | Client C project | short desc C      | long desc C      | Client C |

  Scenario: Click "export to CSV" button
    Given I am on the admin dashboard
    # Then I pause for a while
    When I click "Export to CSV"
    Then I should get a download with the filename "projects.csv"
    Then the downloaded file content should be:
    """
    Project Name,Client Email,Short Description,Long Description
    Client C project,client@clientc.org,short desc C,long desc C
    Client B project,client@clientb.org,short desc B,long desc B
    Client A project,client@clienta.org,short desc A,long desc A
    
    """
