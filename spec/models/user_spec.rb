require 'spec_helper'

describe User do
	before do
	 	@user = User.new(name: "Example user", email: "user@example.com",
										password: "foobar", password_confirmation: "foobar")
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.
		foo@bar_baz.com foo@bar+baz.com foo@bar..com]
		invalid_emails.each do |invalid_email|
			before { @user.email = invalid_email }
			it { should_not be_valid }
		end
	end

	describe "when email format is valid" do
		valid_emails = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
		valid_emails.each do |valid_email|
			before { @user.email = valid_email }
			it { should be_valid }
		end
	end

	describe "when email is already taken" do
		before do
		  name_with_same_email = @user.dup
			name_with_same_email.email.upcase!
		  name_with_same_email.save
		end
		it { should_not be_valid }
	end

	describe "when password is not given" do
		before do
			@user = User.new(name: "Example", email: "user@ex.com",
											password: "", password_digest: "")
		end
		it { should_not be_valid }
	end
	describe "when password doesn't confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a"*5 }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

##6.5.1
	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExamPLe.com" }

		it describe "should saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save

			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end

end
