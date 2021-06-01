const { chromium } = require('playwright');
const expect = require('expect');

describe('login', () => {
  const baseUrl = process.env.BASE_URL

  let browser;
  let page;

  beforeAll(async () => {
    console.log(`Testing url: ${baseUrl}`)

    browser = await chromium.launch({
      headless: true
    });
  });
  afterAll(async () => {
    await browser.close();
  });

  beforeEach(async () => {
    page = await browser.newPage();    
  });
  afterEach(async () => {
    await page.close();
  });

  test('login successfull', async () => {
    await page.goto(baseUrl);
  
    await page.fill('input[name="email"]', 'barney');
    await page.fill('input[name="password"]', 'barneypassword');
  
    await page.click('id=login-button');
    expect(await page.url()).toBe(`${baseUrl}/login`);
    expect(await page.title()).toBe("Dashboard");    

    await page.screenshot({ path: 'screenshots/successfull_login.png', fullPage: true});
  }) 
  
  test('login failed', async () => {
    await page.goto(baseUrl);
  
    await page.fill('input[name="email"]', 'invalid_username');
    await page.fill('input[name="password"]', 'crazy_password_doesnt_exist2314233');
  
    await page.click('id=login-button');
    expect(await page.url()).toBe(`${baseUrl}/login`);
    expect(await page.title()).toBe("Login Failure");
    await page.screenshot({ path: 'screenshots/failed_login.png', fullPage: true});
  })
})
