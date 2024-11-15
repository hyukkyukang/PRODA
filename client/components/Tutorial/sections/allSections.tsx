import TaskOverviewSection from "./taskOverview";
import TaskExampleSimpleSection from "./taskExampleSimple";
import TaskExampleAdvancedSection from "./taskExampleAdvanced";
import ProjectionSection from "./projection";
import Agg1Section from "./agg1";
import Agg2Section from "./agg2";
import Selection1Section from "./selection1";
import Selection2Section from "./selection2";
import Selection3Section from "./selection3";
import GroupingSection from "./grouping";
import OrderingSection from "./ordering";
import ForEachSection from "./forEach";
import MultipleSublinks from "./multisublinks";
import EVQAOverviewSection from "./EVQAOverview";
import { ITutorialSection } from "./abstractSection";

// For easy import from other files
export { TaskOverviewSection as TaskOverviewSection } from "./taskOverview";
export { TaskExampleSimpleSection as TaskExampleSimpleSection } from "./taskExampleSimple";
export { TaskExampleAdvancedSection as TaskExampleAdvancedSection } from "./taskExampleAdvanced";
export { ProjectionSection as ProjectionSection } from "./projection";
export { Agg1Section as Agg1Section } from "./agg1";
export { Agg2Section as Agg2Section } from "./agg2";
export { Selection1Section as Selection1Section } from "./selection1";
export { Selection2Section as Selection2Section } from "./selection2";
export { Selection3Section as Selection3Section } from "./selection3";
export { GroupingSection as GroupingSection } from "./grouping";
export { OrderingSection as OrderingSection } from "./ordering";
export { ForEachSection as ForEachSection } from "./forEach";
export { MultipleSublinks as MultipleSublinks } from "./multisublinks";

// List of all sections
export const basicTutorialSections: ITutorialSection[] = [
    EVQAOverviewSection,
    ProjectionSection,
    Agg1Section,
    Agg2Section,
    Selection1Section,
    Selection2Section,
    OrderingSection,
    GroupingSection,
];

// export const advanceTutorialSections: ITutorialSection[] = [Selection3Section, ForEachSection, MultipleSublinks];
export const advanceTutorialSections: ITutorialSection[] = [Selection3Section];

export const allTutorialSections: ITutorialSection[] = [TaskOverviewSection, TaskExampleSimpleSection, TaskExampleAdvancedSection].concat(
    basicTutorialSections.concat(advanceTutorialSections)
);
