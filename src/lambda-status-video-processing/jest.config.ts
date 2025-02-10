export default {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['<rootDir>/test/**/*.spec.ts'],
  moduleFileExtensions: ['ts', 'tsx', 'js'],
  collectCoverage: true,
  coverageDirectory: "coverage",
  coverageReporters: ["json", "lcov"],
  coverageThreshold: {
    global: {
      lines: 90,
    },
  },
};