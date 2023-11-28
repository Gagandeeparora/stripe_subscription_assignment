# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version - 3.2.2

* Ruby version - 7.1.2

* Database - Need mysql database.

* How to run project.
	1. Clone the repository.
	2. Open the terminal and run bundle install
	3. After this run rails db:migrate for creation of table and seed data in database. 
	4. Stripe credentials are saved on credential.yml file
	5. For testing of webhook events, strip cli can be downloaded and please replace secret with your own machine secret. 
	6. For stripe webhook listen --forward-to  localhost:3000/api/v1/stripe/stripe_events

* I have already created a test plan on stripe dashboad.

* I haven't added test cases for now. But if needed i can write that too.

