module.exports = {
  roots: ['<rootDir>'],
  transform: {},
  reporters: ['default', 'jest-junit'],
  testRegex: '(/__tests__/.*|\\.(test|spec))\\.[tj]sx?$',
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  testTimeout: 60000
}