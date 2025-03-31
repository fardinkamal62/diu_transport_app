import pluginJs from '@eslint/js';
import tsPlugin from '@typescript-eslint/eslint-plugin';
import tsParser from '@typescript-eslint/parser';
import jestPlugin from 'eslint-plugin-jest';

import globals from 'globals';

export default [
    // Base recommended configuration from ESLint
    pluginJs.configs.recommended,

    // TypeScript configuration
    {
        files: ['**/*.ts', '**/*.tsx'],
        languageOptions: {
            ecmaVersion: 2022,	// Use ECMAScript 2022
            parser: tsParser,	// Use the TypeScript parser
            sourceType: 'module',
            globals: {...globals.browser, ...globals.node, ...globals.jest},	// Add browser globals to the list of known globals so that ESLint doesn't complain about them
            parserOptions: {
                project: './tsconfig.json',	// Use the TypeScript project configuration file
            }
        },
        plugins: {
            '@typescript-eslint': tsPlugin, // Use the TypeScript ESLint plugin
            'jest': jestPlugin, // Enable ESLint rules for Jest
        },
        rules: {
            quotes: ['error', 'single'], // Use single quotes for strings
            indent: ['error', 'tab'],	// Use tabs for indentation
            'no-console': ['warn', {allow: ['warn', 'error']}], // Allow 'warn' and 'error' console messages
            '@typescript-eslint/no-unused-vars': ['warn', { argsIgnorePattern: '^_' }], // Ignore unused variables that start with an underscore
            'no-use-before-define': 'warn', // Warn when using a variable before it is declared
            'no-const-assign': 'error', 	// Disallow reassigning a constant
            'no-dupe-args': 'error', 		// Disallow duplicate arguments in function definitions
            'object-curly-spacing': ['error', 'always'],	// Space around curly braces
            '@typescript-eslint/no-explicit-any': 'warn',	// Warn when using the 'any' type
            '@typescript-eslint/no-empty-function': 'off',	// Allow empty functions
            '@typescript-eslint/no-floating-promises': 'error',	// Warn when a promise is not handled
            '@typescript-eslint/explicit-function-return-type': 'error',	// Require explicit return types on functions
            '@typescript-eslint/strict-boolean-expressions': 'error',	// Require strict boolean expressions
            '@typescript-eslint/no-unsafe-assignment': 'error',	// Disallow unsafe assignments

            // Jest rules
            'jest/no-disabled-tests': 'warn',	// Warn when a test is disabled
            'jest/no-focused-tests': 'error',	// Disallow focused tests
            'jest/no-identical-title': 'error',	// Disallow identical test titles
            'jest/valid-expect': 'error',	//
        },
        settings: {
            'import/resolver': {
                typescript: true, // This setting is required to resolve TypeScript files
                node: true,
                extensions: ['.ts', '.tsx', '.js', '.jsx', '.json'],
            },
        },
    },
];
