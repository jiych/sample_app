require 'spec_helper'

describe "UserPages" do
	subject { page }
			before { visit signup_path }
			describe "signup page" do
			it { should have_content('Sign up') }
			it { should have_title(full_title('Sign up')) }
	end
end
