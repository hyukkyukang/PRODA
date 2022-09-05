import { useMemo } from "react";
import { ResponsiveBar, BarDatum } from "@nivo/bar";

interface IChartData {
    queryType: string;
    numOfQueries: number;
}

export const dataStatToChartData = (queryStatData: { [key: string]: number }): IChartData[] => {
    const filteredData = Object.entries(queryStatData).filter(([key, value]) => value > 0);
    const filteredObj: { [key: string]: number } = Object.fromEntries(filteredData);
    return Object.entries(filteredObj).map(([queryType, numOfQueries]) => ({
        queryType: queryType,
        numOfQueries: numOfQueries,
    }));
};

export const SummaryChart = (queryStatData: { [key: string]: number }) => {
    const chartData = useMemo(() => dataStatToChartData(queryStatData), [queryStatData]);
    return (
        <ResponsiveBar
            data={chartData as any}
            keys={["numOfQueries"]}
            indexBy="queryType"
            margin={{ top: 50, right: 130, bottom: 50, left: 60 }}
            padding={0.3}
            valueScale={{ type: "linear" }}
            indexScale={{ type: "band", round: true }}
            colors={{ scheme: "nivo" }}
            defs={[
                {
                    id: "dots",
                    type: "patternDots",
                    background: "inherit",
                    color: "#38bcb2",
                    size: 4,
                    padding: 1,
                    stagger: true,
                },
                {
                    id: "lines",
                    type: "patternLines",
                    background: "inherit",
                    color: "#eed312",
                    rotation: -45,
                    lineWidth: 6,
                    spacing: 10,
                },
            ]}
            fill={[]}
            borderColor={{
                from: "color",
                modifiers: [["darker", 1.6]],
            }}
            axisTop={null}
            axisRight={null}
            axisBottom={{
                tickSize: 5,
                tickPadding: 5,
                tickRotation: 0,
                legend: "Query Type",
                legendPosition: "middle",
                legendOffset: 32,
            }}
            axisLeft={{
                tickSize: 5,
                tickPadding: 5,
                tickRotation: 0,
                legend: "Number of collected queries",
                legendPosition: "middle",
                legendOffset: -40,
            }}
            labelSkipWidth={12}
            labelSkipHeight={12}
            labelTextColor={{
                from: "color",
                modifiers: [["darker", 1.6]],
            }}
            // legends={[
            //     {
            //         dataFrom: "keys",
            //         anchor: "bottom-right",
            //         direction: "column",
            //         justify: false,
            //         translateX: 120,
            //         translateY: 0,
            //         itemsSpacing: 2,
            //         itemWidth: 100,
            //         itemHeight: 20,
            //         itemDirection: "left-to-right",
            //         itemOpacity: 0.85,
            //         symbolSize: 20,
            //         effects: [
            //             {
            //                 on: "hover",
            //                 style: {
            //                     itemOpacity: 1,
            //                 },
            //             },
            //         ],
            //     },
            // ]}
            role="application"
            ariaLabel="Nivo bar chart demo"
            barAriaLabel={function (e) {
                return e.id + ": " + e.formattedValue + " in country: " + e.indexValue;
            }}
        />
    );
};

export default SummaryChart;
