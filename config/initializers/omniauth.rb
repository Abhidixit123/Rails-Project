Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV['1081730732497-o1du6ou91afpci72hf4e3ldjl9v30i9e.apps.googleusercontent.com
'], ENV['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'], {
      scope: 'email,profile',
      prompt: 'select_account'
    }
  end
  