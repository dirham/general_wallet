# General Wallet < Rails Api Only 

This app created using ruby on rails api only, however to login it uses sessions and set the client header to add cookies.

* Available routes:
```ruby
    post "login", to: "sessions#create", as: :login_sessions

    # routes could be access at:
    # http://{host}/api/deposit|transfer|balance|withdraw
    scope "api" do
        post "deposit", to: "wallets#deposit"
        post "transfer", to: "wallets#transfer"
        get "balance", to: "wallets#balance"
        post "withdraw", to: "wallets#withdrawal"
    end
```

* Run test
```bash
bin/rails test
```
* Ruby version
    
    ruby 3.1.6p260 

* System dependencies

* Configuration
    
    To use LatestStockPrice library, you need to add environment variable for:

    - .env (works for development and test)
    ```
    RAPID_API_KEY=your-rapid-key
    RAPID_API_HOST=rapid-host
    ```
    - productions:
        - unix (linux and macos):
        `export RAPID_API_KEY="your-rapid-key"`
        `export RAPID_API_HOST="your-rapid-host"`
        - windows:
        setting on windows command prompt
            `set RAPID_API_KEY=your-rapid-key`
            `set RAPID_API_HOST=your-rapid-host`
        or on system properties:
        ```
        Permanently (for all sessions): 
        To set an environment variable permanently, you can use the System Properties:
        - Right-click on This PC or My Computer and select Properties.
        - Click on Advanced system settings.
        - In the System Properties window, click the Environment Variables button.
        - In the Environment Variables window, you can add a new variable under User variables or
        - System variables by clicking New.
        - Enter the Variable name (e.g., RAPID_API_KEY) and the Variable value (e.g., somev94942kj).
        - Click OK to close all the dialogs.
        ```

* Database creation
    ```bash
    bin/rake db:migrate:reset
    ```

* Database initialization
    ```bash
    bin/rails db:seed
    ```
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
