test('smoke test', () => {
  expect(true).toBe(true)
})

test('environment is test', () => {
  expect(process.env.NODE_ENV).toBe('test')
})