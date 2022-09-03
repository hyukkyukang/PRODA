import ProjectionSection from "./projection";
import Agg1Section from "./agg1";
import Agg2Section from "./agg2";
import Selection1Section from "./selection1";
import Selection2Section from "./selection2";
import Selection3Section from "./selection3";
import GroupingSection from "./grouping";
import OrderingSection from "./ordering";
import NestingSection from "./nesting";
import ForEachSection from "./forEach";
import { ITutorialSection } from "./abstractSection";

// For easy import from other files
export { ProjectionSection as ProjectionSection } from "./projection";
export { Agg1Section as Agg1Section } from "./agg1";
export { Agg2Section as Agg2Section } from "./agg2";
export { Selection1Section as Selection1Section } from "./selection1";
export { Selection2Section as Selection2Section } from "./selection2";
export { Selection3Section as Selection3Section } from "./selection3";
export { GroupingSection as GroupingSection } from "./grouping";
export { OrderingSection as OrderingSection } from "./ordering";
export { NestingSection as NestingSection } from "./nesting";
export { ForEachSection as ForEachSection } from "./forEach";

// List of all sections
export const allTutorialSections: ITutorialSection[] = [
    ProjectionSection,
    Agg1Section,
    Agg2Section,
    Selection1Section,
    Selection2Section,
    Selection3Section,
    GroupingSection,
    OrderingSection,
    NestingSection,
    ForEachSection,
];

export default allTutorialSections;
