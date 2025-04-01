import mongoose from 'mongoose';


const userSchema = new mongoose.Schema({
	name: {
		type: String,
		required: true,
	},
	username: {
		type: String,
		unique: true,
		maxlength: 100,
	},
	email: {
		type: String,
		unique: true,
		maxlength: 255,
		validate: {
			validator: function(v: string): boolean {
				return /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(v);
			},
			message: (props: { value: any; }) : string => `${props.value} is not a valid email!`
		}
	},
	picture: {
		type: String,
		required: false,
		default: '',
	},
	phoneNumber: {
		type: String,
		unique: true,
		validate: {
			validator: function(v: string): boolean {
				return /^(\+8801|01)[3-9][0-9]{8}$/.test(v);
			},
			message: (props: { value: any; }): string => `${props.value} is not a valid phone number!`
		}
	},
	password: {
		type: String,
		required: true,
	},
	groups: {
		type: Array,
		default: [],
	},
	createdAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	updatedAt: {
		type: Date,
		default: ():Date => new Date(),
	},
	deletedAt: {
		type: Date,
		default: null,
	}
}, { autoIndex: false });

userSchema.path('email').validate(function(value: string) {
	return this.phoneNumber || value;
}, 'Either email or phone number is required!');

userSchema.path('phoneNumber').validate(function(value: string) {
	return this.email || value;
}, 'Either email or phone number is required!');

const User = mongoose.model('User', userSchema);

const schemas = {
	User,
}

export default schemas;

