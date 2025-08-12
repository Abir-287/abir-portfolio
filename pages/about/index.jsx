import { motion } from "framer-motion";
import { useState } from "react";
import CountUp from "react-countup";

import {
  FaCss3,
  FaFigma,
  FaHtml5,
  FaJs,
  FaReact,
  FaWordpress,
  FaDocker,
  FaLinux,
  FaPython,
  FaJava,
  FaGitAlt,
} from "react-icons/fa";

import {
  SiAdobephotoshop,
  SiAdobexd,
  SiFramer,
  SiNextdotjs,
  SiAmazonaws,
  SiGithubactions,
  SiGnubash,
  SiC,
  SiTypescript,
  SiMysql,
  SiFirebase,
  SiVisualstudiocode,
  SiAndroidstudio,
  SiWireshark,
} from "react-icons/si";

import Avatar from "../../components/Avatar";
import Circles from "../../components/Circles";
import { fadeIn } from "../../variants";


//  data

export const aboutData = [
  {
    title: " skills",
    info: [
      {
        title: "DevOps & Cloud",
        icons: [SiAmazonaws, FaDocker, SiGithubactions, FaLinux, FaGitAlt],
      },
      {
        title: "Cybersecurity & Networking",
        icons: [SiWireshark],
      },
      {
        title: "Programming",
        icons: [FaPython, SiGnubash, SiC, FaJs, SiTypescript, FaJava],
      },
      {
        title: "Databases & Big Data",
        icons: [SiMysql, SiFirebase],
      },
      {
        title: "Tools",
        icons: [SiVisualstudiocode, SiAndroidstudio],
      },
    ],
  },
  {
    title: "education",
    info: [
      {
        title:
          "  Embedded Telecommunications Engineering \n National School of Engineers of Sousse, Tunisia",
        stage: "      Ongoing",
      },
      {
        title:
          "Joint Degree Program in Digital Media Art Design \n Beijing Polytechnic, China",
        stage: "        2024",
      },
      {
        title:
          "Preparatory Studies for Engineering (Physics & Mathematics) \n Higher School of Sciences and Technology of Hammam Sousse , Tunisia",
        stage: "2023",
      },
    ],
  },
  {
    title: "experience",
    info: [
      {
        title: "DevOps Intern — Proxym",
        stage: "2025",
      },
      {
        title: "DevOps Training — Orange Digital Center ",
        stage: "2025",
      },
      {
        title: "Web Development Intern — Municipality of Sousse",
        stage: "2024",
      },
    ],
  },
  {
    title: "certificates",
    info: [
      {
        title: "AWS Academy Cloud Foundations — AWS",
        stage: "2025",
      },
      {
        title: "Red Hat System Administration I (RH124) — Red Hat",
        stage: "2025",
      },
      {
        title: "IBM Cybersecurity Professional Certificate — IBM",
        stage: "2025",
      },
    ],
  },
];



const About = () => {
  const [index, setIndex] = useState(0);

  return (
    <div className="h-full bg-primary/30 py-32 text-center xl:text-left">
      <Circles />

      {/* avatar img */}
      <motion.div
        variants={fadeIn("right", 0.2)}
        initial="hidden"
        animate="show"
        exit="hidden"
        className="hidden xl:flex absolute bottom-100 -left-[250px]"
      >
        <Avatar />
      </motion.div>

      <div className="container mx-auto h-full flex flex-col items-center xl:flex-row gap-x-6 xl:pl-12 mt-8 ">
        {/* text */}
        <div className="flex-1 flex flex-col justify-center">
          <motion.h2
            variants={fadeIn("right", 0.2)}
            initial="hidden"
            animate="show"
            exit="hidden"
            className="h2"
          >
           Building <span className="text-accent">secure</span> solutions with creative precision.
          </motion.h2>
          <motion.p
            variants={fadeIn("right", 0.4)}
            initial="hidden"
            animate="show"
            className="max-w-[500px] mx-auto xl:mx-0 mb-6 xl:mb-12 px-2 xl:px-0"
          >
I am a final-year Embedded Telecommunications Engineering student with a deep interest in cloud technologies, DevOps and DevSecOps. I thrive on designing secure, automated and scalable systems from CI/CD pipelines to cloud-native architectures, always with a security-first mindset. Combining problem-solving skills, adaptability and teamwork, I aim to build technology that is both innovative and reliable.          </motion.p>

          {/* counters */}
          <motion.div
            variants={fadeIn("right", 0.6)}
            initial="hidden"
            animate="show"
            className="hidden md:flex md:max-w-xl xl:max-w-none mx-auto xl:mx-0 mb-8"
          >
           <div className="flex flex-1 xl:gap-x-6">
  {/* years in engineering */}
  <div className="relative flex-1 after:w-[1px] after:h-full after:bg-white/10 after:absolute after:top-0 after:right-0">
    <div className="text-2xl xl:text-4xl font-extrabold text-accent mb-2">
      <CountUp start={0} end={4} duration={5} />
    </div>
    <div className="text-xs uppercase tracking-[1px] leading-[1.4] max-w-[120px]">
      Years in engineering.
    </div>
  </div>

  {/* internships & trainings */}
  <div className="relative flex-1 after:w-[1px] after:h-full after:bg-white/10 after:absolute after:top-0 after:right-0">
    <div className="text-2xl xl:text-4xl font-extrabold text-accent mb-2">
      <CountUp start={0} end={3} duration={5} />
    </div>
    <div className="text-xs uppercase tracking-[1px] leading-[1.4] max-w-[120px]">
      Internships & trainings.
    </div>
  </div>

  {/* projects */}
  <div className="relative flex-1 after:w-[1px] after:h-full after:bg-white/10 after:absolute after:top-0 after:right-0">
    <div className="text-2xl xl:text-4xl font-extrabold text-accent mb-2">
      <CountUp start={0} end={5} duration={5} />
    </div>
    <div className="text-xs uppercase tracking-[1px] leading-[1.4] max-w-[120px]">
      Projects delivered.
    </div>
  </div>

  {/* certifications */}
  <div className="relative flex-1">
    <div className="text-2xl xl:text-4xl font-extrabold text-accent mb-2">
      <CountUp start={0} end={8} duration={5} />
    </div>
    <div className="text-xs uppercase tracking-[1px] leading-[1.4] max-w-[120px]">
      Certifications earned.
    </div>
  </div>
</div>

          </motion.div>
        </div>

        {/* info */}
        <motion.div
          variants={fadeIn("left", 0.4)}
          initial="hidden"
          animate="show"
          exit="hidden"
          className="flex flex-col w-full xl:max-w-[48%] h-[480px]"
        >
          <div className="flex gap-x-4 xl:gap-x-8 mx-auto xl:mx-0 mb-4">
            {aboutData.map((item, itemI) => (
              <div
                key={itemI}
                className={`${
                  index === itemI &&
                  "text-accent after:w-[100%] after:bg-accent after:transition-all after:duration-300"
                } cursor-pointer capitalize xl:text-lg relative after:w-8 after:h-[2px] after:bg-white after:absolute after:-bottom-1 after:left-0`}
                onClick={() => setIndex(itemI)}
              >
                {item.title}
              </div>
            ))}
          </div>

          <div className="py-2 xl:py-6 flex flex-col gap-y-2 xl:gap-y-4 items-center xl:items-start">
            {aboutData[index].info.map((item, itemI) => (
              <div
                key={itemI}
                className="flex-1 flex flex-col md:flex-row max-w-max gap-x-2 items-center text-center text-white/60"
              >
                {/* title */}
               <div className="mb-2 md:mb-0 text-center md:text-left">
  {item.title.split("\n").map((line, i) => (
    <div
      key={i}
      className={i === 0 ? "font-bold" : "italic text-white/70"}
    >
      {line}
    </div>
  ))}
</div>
                <div className="hidden md:flex whitespace-pre-wrap">-</div>
                <div>{item.stage}</div>

                <div className="flex gap-x-4">
                  {/* icons */}
                  {item.icons?.map((Icon, iconI) => (
                    <div key={iconI} className="text-2xl text-white">
                      <Icon />
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default About;
