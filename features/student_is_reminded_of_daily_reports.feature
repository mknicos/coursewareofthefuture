Feature: Student is reminded of daily reports

  Acceptance Criteria: A reminder email is sent to students at 9pm each evening if no form has been submitted for the previous day.

  Background:
    Given the following course:
      | title      | Cohort 4   |
      | start_date | 2013/03/11 |
      | end_date   | 2013/06/20 |
    And that course has 1 student
    And I am signed in as that student
    And no emails have been sent

  Scenario: Reminder email is sent on day-of
    Given that it is 2013/03/11 8:00AM
    When the cron job runs
    Then I should receive 1 email
    When I open the email
    Then I should see "Reminder: Enter Your Self-Report" in the email subject
    When I follow "Enter your self-report!" in the email
    Then I should be on the course calendar for Cohort 4

  Scenario: Reminder email is not sent if the self-report has been entered
    Given that it is 2013/03/11 8:00AM
    And that user has the following self reports:
      | date       | attended | hours_coding | hours_slept | hours_learning |
      | 2013/03/10 | false    | 5            | 9           | 0              |
    When the cron job runs
    Then I should receive no email

  Scenario: Reminder email when there are multiple missing days
    Given that it is 2013/03/15 8:00AM
    And that user has the following self reports:
      | date       | attended | hours_coding | hours_slept | hours_learning |
      | 2013/03/12 | false    | 5            | 9           | 0              |
      | 2013/03/11 | true     | 2            | 7.5         | 4              |
    When the cron job runs
    Then I should receive 1 email
    When I open the email
    Then I should see "Reminder: Enter Your Self-Report" in the email subject
    When I follow "Enter your self-report!" in the email
    Then I should be on the course calendar for Cohort 4
