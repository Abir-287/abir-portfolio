import { Sora } from "next/font/google";
import Head from "next/head";

import Header from "../components/Header";
import Nav from "../components/Nav";
import TopLeftImg from "../components/TopLeftImg";

// setup font
const sora = Sora({
  subsets: ["latin"],
  variable: "--font-sora",
  weight: ["100", "200", "300", "400", "500", "600", "700", "800"],
});

const Layout = ({ children }) => {
  return (
    <main
      className={`page bg-site text-white bg-cover bg-no-repeat ${sora.variable} font-sora relative`}
    >
      {/* metadata */}
      <Head>
        <title>Abir Ben Nasr | Portfolio</title>
        <meta
          name="description"
          content="Abir Ben Nasr is an ICT engineering student passionate about DevOps, cloud computing, and system security."
        />
        <meta
          name="keywords"
          content="DevOps, cloud computing, system security, ICT engineering, portfolio, Linux, AWS, web development, CI/CD, Docker"
        />
        <meta name="author" content="Abir Ben Nasr" />
        <meta name="theme-color" content="#f13024" />
      </Head>

      <TopLeftImg />
      <Nav />
      <Header />

      {/* main content */}
      {children}
    </main>
  );
};

export default Layout;
