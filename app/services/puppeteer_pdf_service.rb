class PuppeteerPdfService
  def initialize(html_content, pdf_options = {}, template_name)
    @html_content = html_content
    @pdf_options = pdf_options
    @template_name = template_name
  end

  def generate
    file_path = Rails.root.join("tmp", "resume_#{@template_name[:template_identifier]}.pdf")
    begin
      puppeteer_script = <<~JS
        const puppeteer = require('puppeteer');
        (async () => {
          try {
            const browser = await puppeteer.launch({ args: ['--no-sandbox', '--disable-setuid-sandbox'] });
            const page = await browser.newPage();
            await page.setContent(`#{@html_content}`);
            await page.pdf({
              path: '#{file_path}',
              format: 'A3',
              margin: { top: 20, bottom: 20, left: 0, right: 10 },
              printBackground: true
            });
            await browser.close();
          } catch (error) {
            console.error("Puppeteer error:", error);
            throw error;
          }
        })();
      JS

      script_file_path = Rails.root.join("tmp", "puppeteer_script_#{SecureRandom.hex}.js")
      File.open(script_file_path, 'w') { |file| file.write(puppeteer_script) }
      system("node #{script_file_path}")
      File.delete(script_file_path)

      unless File.exist?(file_path)
        raise "PDF file was not generated"
      end

      file_path
    rescue => e
      Rails.logger.error "PDF generation failed: #{e.message}"
      nil
    end
  end
end
